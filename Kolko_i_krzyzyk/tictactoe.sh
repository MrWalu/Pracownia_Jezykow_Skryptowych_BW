#!/bin/bash

function print_board() {
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "---+---+---"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "---+---+---"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "
}

function check_winner() {
    local player=$1
    for i in 0 3 6; do
        if [[ ${board[$i]} == $player && ${board[$((i+1))]} == $player && ${board[$((i+2))]} == $player ]]; then
            return 0
        fi
    done

    for i in 0 1 2; do
        if [[ ${board[$i]} == $player && ${board[$((i+3))]} == $player && ${board[$((i+6))]} == $player ]]; then
            return 0
        fi
    done

    if [[ ${board[0]} == $player && ${board[4]} == $player && ${board[8]} == $player ]]; then
        return 0
    fi

    if [[ ${board[2]} == $player && ${board[4]} == $player && ${board[6]} == $player ]]; then
        return 0
    fi

    return 1
}

function is_board_full() {
    for i in "${board[@]}"; do
        if [[ $i == " " ]]; then
            return 1
        fi
    done
    return 0
}

function computer_move() {
    echo "Computer makes a move"
    while true; do
        move=$((RANDOM % 9))
        if [[ ${board[$move]} == " " ]]; then
            board[$move]="O"
            break
        fi
    done
}

function player_move() {
    local current_player=$1
    while true; do
        echo "Player $current_player, choose field (1-9):"
        read move

        if [[ ! "$move" =~ ^[1-9]$ ]] || [[ ${board[$((move-1))]} != " " ]]; then
            echo "Incorrect move, try again."
            continue
        fi

        board[$((move-1))]=$current_player
        break
    done
}

function play_game() {
    local game_mode="1"
    echo "Choose game mode:"
    echo "1. 2 players"
    echo "2. Play with computer"
    read game_mode

    while true; do
        print_board

        if [[ $game_mode == "1" ]]; then
            player_move "$current_player"
        elif [[ $game_mode == "2" ]]; then
            if [[ $current_player == "X" ]]; then
                player_move "$current_player"
            else
                computer_move
            fi
        else
            echo "Incorrect game mode. Choose 1 or 2."
            read game_mode
            continue
        fi

        if check_winner "$current_player"; then
            print_board
            if [[ $current_player == "X" ]]; then
                echo "Congratulations! Player X won"
            else
                echo "Computer won!"
            fi
            break
        fi

        if is_board_full; then
            print_board
            echo "That's a draw! Field is full."
            break
        fi

        if [[ $current_player == "X" ]]; then
            current_player="O"
        else
            current_player="X"
        fi
    done
}

board=(" " " " " " " " " " " " " " " ")
current_player="X"

play_game
