require 'ruby2d'

# Ustawienia okna
set title: "Mario2D", width: 640, height: 480

# Grafiki
BACKGROUND = Image.new('mario-background.png', x: 0, y: 0, width: 640, height: 480)
mario = Sprite.new('mario.png', width: 40, height: 40, x: 50, y: 400)

# Zmienne gry
gravity = 1
velocity_y = 0
score = 0
lives = 3
on_ground = false

# Przeszkody, dziury, punkty
obstacles = []
holes = []
points = []

# Wczytaj poziom z pliku
def load_level(file, obstacles, holes, points)
  level_data = File.readlines(file).map(&:strip)
  level_data.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      case char
      when '#'
        obstacles << Image.new('grass.png', x: x * 40, y: y * 40, width: 40, height: 40)
      when 'O'
        holes << { x: x * 40, y: y * 40, width: 40, height: 40 }
      when '*'
        points << Image.new('coin.png', x: x * 40, y: y * 40, width: 20, height: 20)
      end
    end
  end
end

# Kolizja
def collision?(obj1, obj2)
  obj1.x < obj2.x + obj2.width &&
    obj1.x + obj1.width > obj2.x &&
    obj1.y < obj2.y + obj2.height &&
    obj1.y + obj1.height > obj2.y
end

# Lądowanie na przeszkodzie
def land_on_ground(mario, obstacles, velocity_y)
  obstacles.each do |obstacle|
    if mario.y + mario.height >= obstacle.y && # Kolizja od góry
       mario.y + mario.height - velocity_y <= obstacle.y &&
       mario.x + mario.width > obstacle.x &&
       mario.x < obstacle.x + obstacle.width
      mario.y = obstacle.y - mario.height # Lądowanie na przeszkodzie
      return true
    end
  end
  false
end

# Kolizja z przeszkodą od dołu
def hit_head(mario, obstacles, velocity_y)
  obstacles.each do |obstacle|
    if mario.y <= obstacle.y + obstacle.height && # Kolizja od dołu
       mario.y - velocity_y >= obstacle.y + obstacle.height &&
       mario.x + mario.width > obstacle.x &&
       mario.x < obstacle.x + obstacle.width
      mario.y = obstacle.y + obstacle.height # Odbicie od przeszkody
      return true
    end
  end
  false
end

# Sprawdzenie, czy Mario jest nad dziurą
def over_hole?(mario, holes)
  holes.any? do |hole|
    mario.x + mario.width > hole[:x] &&
    mario.x < hole[:x] + hole[:width] &&
    mario.y + mario.height >= hole[:y]
  end
end

# Sprawdzenie, czy Mario ma pod sobą podłoże
def ground_below?(mario, obstacles)
  obstacles.none? do |obstacle|
    mario.x + mario.width > obstacle.x &&
    mario.x < obstacle.x + obstacle.width &&
    mario.y + mario.height <= obstacle.y &&
    mario.y + mario.height + 5 >= obstacle.y
  end
end

# Sterowanie
on :key_held do |event|
  case event.key
  when 'left'
    mario.x -= 5
    obstacles.each do |obstacle|
      mario.x += 5 if collision?(mario, obstacle)
    end
  when 'right'
    mario.x += 5
    obstacles.each do |obstacle|
      mario.x -= 5 if collision?(mario, obstacle)
    end
  end
end

# Skakanie
on :key_down do |event|
  if event.key == 'space' && on_ground
    velocity_y = -15
    on_ground = false
  end
end

# Pętla gry
update do
  velocity_y += gravity
  mario.y += velocity_y

  # Kolizja z przeszkodami - od góry i dołu
  if land_on_ground(mario, obstacles, velocity_y)
    velocity_y = 0
    on_ground = true
  elsif hit_head(mario, obstacles, velocity_y)
    velocity_y = 2 # Lekki "odbicie" w dół
  elsif mario.y >= 400 && !over_hole?(mario, holes) # Dolna krawędź bez dziury
    mario.y = 400
    velocity_y = 0
    on_ground = true
  else
    on_ground = false
  end

  # Spadanie w dziurę
  if over_hole?(mario, holes) && ground_below?(mario, obstacles)
    velocity_y += 2
    if mario.y > 480
      mario.x = 50
      mario.y = 400
      lives -= 1
      puts "Życia: #{lives}"
      close if lives <= 0
    end
  end

  # Zbieranie punktów
  points.each do |point|
    if collision?(mario, point)
      point.remove
      points.delete(point)
      score += 10
      puts "Punkty: #{score}"
    end
  end
end

# Wczytaj poziom
load_level('level1.txt', obstacles, holes, points)

# Start gry
show
