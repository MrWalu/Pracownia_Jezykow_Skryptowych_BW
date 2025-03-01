import json
import os
from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher

# Wczytaanie plikow z JSON
def load_json(file_name):
    with open(file_name, "r", encoding="utf-8") as file:
        return json.load(file)

opening_hours = load_json("opening_hours.json")
menu = load_json("menu.json")

class ActionGetOpeningHours(Action):
    def name(self) -> Text:
        return "action_get_opening_hours"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        message = "Our opening hours:\n"
        for day, hours in opening_hours["items"].items():
            open_time = hours["open"]
            close_time = hours["close"]
            if open_time == 0 and close_time == 0:
                message += f"{day}: Closed\n"
            else:
                message += f"{day}: {open_time}:00 - {close_time}:00\n"

        dispatcher.utter_message(text=message)
        return []

class ActionGetOpeningHoursDays(Action):
    def name(self) -> Text:
        return "action_get_opening_hours_days"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        day = tracker.get_slot("day")
        if day:
            day = day.capitalize()

        if day and day in opening_hours["items"]:
            open_time = opening_hours["items"][day]["open"]
            close_time = opening_hours["items"][day]["close"]
            if open_time == 0 and close_time == 0:
                message = f"{day}: We are closed."
            else:
                message = f"{day}: Open from {open_time}:00 to {close_time}:00."
        else:
            message = "I'm sorry, we are closed at that time."

        dispatcher.utter_message(text=message)
        return []

class ActionDisplayMenu(Action):
    def name(self) -> Text:
        return "action_display_menu"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        message = "Here's our menu:\n"
        for item in menu["items"]:
            message += f"{item['name']} - ${item['price']}\n"

        dispatcher.utter_message(text=message)
        return []

class ActionPlaceOrder(Action):
    def name(self) -> Text:
        return "action_place_order"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        meals = tracker.get_slot("meal")
        if not meals:
            dispatcher.utter_message(text="I couldn't recognize what you want to order. Could you rephrase?")
            return []

        message = "You have ordered:\n"
        for meal in meals:
            message += f"- {meal}\n"

        dispatcher.utter_message(text=message)
        return []