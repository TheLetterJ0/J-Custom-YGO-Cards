These cards were all created to allow for additional formats and game modes in [Project Ignis's EDOPro](https://projectignis.github.io).

This repo currently contains:
- Momir
  - An adaptation of MTG's Momir format.
  - Summons random Main and/or Extra Deck Monsters.
  - Also includes "Generic Monster/Spell/Trap" cards to be used as your Main Deck.
- Duel Rule: Monsters Are All Types
  - Allows for use of this rule outside of the Battle Pack format.
- The Heart of the Cards
  - A skill card replicating the anime ability to always draw what you need, especially as your LP get lower.

## How To Use
Open your `ProjectIgnis\config` folder and look for your `user-configs.json` file there.

If that file does not already exist, use a text editor like Notepad to create it and paste the following into it:

```
{
    "repos": [
        {
            "url": "https://github.com/TheLetterJ0/J-Custom-YGO-Cards",
            "repo_name": "J's Custom Cards",
            "repo_path": "./repositories/j-custom-cards",
            "lflist_path": ".",
            "script_path": "./script",
            "pics_path": "./pics",
            "should_update": true,
            "should_read": true,
        }
    ]
}
```

If you do already have a `user-configs.json` file, open it in a text editor like Notepad and add the lines between and including the inner `{}`s above into your existing list of repos.

Your final result should look something like this:

```
{
    "repos": [
        {
            "repo_name": "A Different Repo",
            "other_lines": "will be here",
        },
        {
            "url": "https://github.com/TheLetterJ0/J-Custom-YGO-Cards",
            "repo_name": "J's Custom Cards",
            "repo_path": "./repositories/j-custom-cards",
            "lflist_path": ".",
            "script_path": "./script",
            "pics_path": "./pics",
            "should_update": true,
            "should_read": true,
        }
    ],
    "urls": [
        {
            "url": "https:www.example.com",
        }
    ]
}
```

Once the `user-configs.json` file is updated, EDOPro will automatically download everything needed for the cards to work the next time you open it. It will also automatically keep the files up to date.

The cards can all be found in the deck building screen by checking the `Alternate Formats` checkbox and searching for the cards' names.

## How To Remove
Undo the steps you followed in the above section. If you created a new `user-configs.json` file, delete it. If you already had one, just delete the parts you added.

Then delete the `ProjectIgnis/repositories/j-custom-cards` folder.

## Playing Momir
The "Dark Factory of Momir Vig Production" Skill card provides two possible skill effects. At the start of the duel, you will be asked which you want to enable. You can choose either or both. The two options are:
- Main Deck Momir
  - Once per turn, you can discard a card to put a counter on the Momir Skill card. (Note that EDO will not actually show you the number of counters on skill cards.)
  - Once per turn, you can discard a card and choose a level up to the number of counters on the Momir Skill card to summon a random Main Deck monster of that level.
  - This mode is intended to be played with a Main Deck consisting of the Momir Skill card, 20 copies of "Generic Monster", 10 copies of "Generic Spell", and 10 copies of "Generic Trap", all of which are also included in this repo.
    - The "Generic X" cards are intended to be used primarily to be discarded to the Momir Skill. But if the Monsters you get let you use them in other ways, doing so is fair game.
    - The "Generic X" cards are made to count as every card type, attribute, archetype, and so on. So nearly any search or similar effect you get should work with them.
- Extra Deck Momir
  - Allows you to summon random Synchro and Xyz Monsters by using two appropriate monsters you control as material.
  - The Level/Rank of the random Monster will correctly match the levels of the materials used.
  - The Monsters will be considered to be correctly Synchro/Xyz summoned.
  - Monsters that cannot normally be summoned with 2 generic materials will be treated as if they can.
    - If an Xyz monster normally requires 3+ materials, and you control that many materials, you will be given a choice between two "Xyz Summon" buttons. The top one will summon it with its normal summoning condition, using the usual number of materials. The bottom button will use the Momir summoning condition of just two Monsters.
  - This mode was meant to be used alongside the Main Deck Momir. But there's nothing stopping you from trying to play a normal Main Deck with randomized Extra Deck summons.

Notes for Both Modes:
- If you are under any lock, floodgate, or other summoning restrictions, the Momir skills will only summon Monsters that you are able to summon under those restrictions. You may be able to use this to your advantage.
  - If there are no monsters that are possible to summon under your current restrictions, you will be told so when you try to summon, and you will not have to discard a card if summoning a Main Deck Monster.
  - If you know there are no possible monsters that could be summoned under your current restrictions, (for example, there are two different Barrier Statues active), please do not try. The program will try to check anyway, making it appear unresponsive for several seconds.

[This video](https://www.youtube.com/watch?v=3UENoU7JZLA) shows Momir being played with both options. (At the time of recording, there were some bugs and balance issues that have since been fixed.)

## Help/Contact
The best way to contact me is by joining the [Discord for my bigger project, the YGO Scrambler](https://discord.gg/sCQWRkRYPk). Feel free to ask for help, report bugs, make suggestions, share your experiences, find people to play with, or just hang out there.
