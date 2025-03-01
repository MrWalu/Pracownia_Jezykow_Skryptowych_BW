import discord
import requests
import os
from discord.ext import commands

# Pobranie tokena bota z zmiennych środowiskowych
TOKEN = os.getenv("DISCORD_TOKEN")
if not TOKEN:
    raise RuntimeError("Brak ustawionego tokena dla Discorda!")

# Adres webhooka Rasa
RASA_URL = "http://localhost:5005/webhooks/rest/webhook"

# Konfiguracja uprawnień
intents = discord.Intents.default()
intents.message_content = True

# Tworzenie instancji bota
bot = commands.Bot(command_prefix="?", intents=intents)

@bot.event
async def on_ready():
    """Wykonuje się po zalogowaniu bota"""
    print(f"{bot.user} jest aktywny i gotowy do pracy!")

@bot.event
async def on_message(message):
    """Reaguje na wiadomości użytkowników"""
    if message.author == bot.user:
        return  # Ignorowanie wiadomości od samego bota

    payload = {"sender": str(message.author), "message": message.content}

    try:
        response = requests.post(RASA_URL, json=payload)
        response.raise_for_status()  # Sprawdzenie, czy nie było błędu HTTP
        data = response.json()

        if data:
            for msg in data:
                await message.channel.send(msg.get("text", "Nie rozumiem..."))
        else:
            await message.channel.send("Brak odpowiedzi od serwera.")
    except requests.RequestException:
        await message.channel.send("Wystąpił błąd podczas komunikacji z serwerem.")

bot.run(TOKEN)