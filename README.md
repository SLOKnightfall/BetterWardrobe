# Better Wardrobe and Transmog [![](http://cf.way2muchnoise.eu/401253.svg)](https://www.curseforge.com/wow/addons/better-wardrobe-and-transmog)[![](http://img.shields.io/badge/runs-retail-brightgreen)](https://www.curseforge.com/wow/addons/better-wardrobe-and-transmog)

[![](https://media.forgecdn.net/attachments/76/25/patreon-medium-button.png)](https://www.patreon.com/SLOKnightfall)

Tired of not being able to Transmog incomplete sets or the many dungeon/leveling sets not found in the default set list? Better Wardrobe & Transmog was created to solve these issues and to improve the transmog experience without needing a host of additional addons installed. It adds new features to the Collection Journal, Transmog Vendor, Dressing Room and tooltip pages.

## Features

### General Improvements

- Collection Alerts: Alerts are printed in the chat window if a set, extra set, or collection list appearance was learned.
- Improved Artifact section of the Collection Journal: When viewing the Legion Artifact section of the Item Collection Journal, it now shows collected & the uncollected weapon appearances for all the weapon types. The uncollected appearances have info on how to unlock them in the tooltips. Also for Druids, the shape shift forms are shown for the Fangs of Ashamane and Claws of Ursoc instead of the base weapons. Very nice now that the transmog restrictions on artifacts have been removed, so you can see what still needs to be unlocked without having to find the artifact and go back to the class hall.

### Alt-Appearance Detection

- Has an Alternate Look Available: If an appearance you're looking at can also be unlocked a different way (a recolor, a different source item, etc.), a small badge appears on the item icon - both in the Collection Journal and at the Transmog vendor. Click it to see every known alternate source and jump straight to that item. Toggle this on/off in the options.

### Improved Collection Journal

- Listings for Additional Transmog Sets: Adds listing to the Set Collections page for additional outfits. These include dungeon, questing, event sets and many more from the WoWhead transmog set database. These sets display like the base sets with a listing of set completion for incomplete sets and a different highlight for completed sets. *Note that many of the recolor/lookalike sets appear to be missing pieces or wrong piece types, this is because many of the sets are actually incomplete on their listing on WoWHead.*
- Saved Sets Tab: If a character has any custom saved sets a new tab will be shown that lists them.
- Shared Sets: An account-wide (not per-character) pool of saved sets you can pull from on any character. If you have Narcissus installed, this reads and writes its Shared Sets pool directly; if not, BetterWardrobe keeps its own fallback pool so the feature works either way.
- View Another Character's Saved Sets: A searchable, class-colored character picker lets you browse and load saved sets from any of your other characters, not just the one you're currently on.
- Favorite Extra Sets: You can now set favorites in the extra sets list.
- Visual View of the Collection Sets: By clicking the Eye icon in the Collection Sets menu, you can switch from a list view to a visual view of all the sets, similar to when at the transmog vendor.
- AutoHide Set Preview Slots: A menu button has been added to the lower left of the set preview window. It allows you to toggle the hiding of the selected slots. The slot selection is linked to the AutoHide Transmog Slots menu so you can always see how it looks when you transmog it.
- Transmog Queue: You can now queue a set or extra set to be transmoged directly from the Collections Journal. This is done by right clicking on the set and selecting Queue Set. Then at the transmog vendor just click on the "Import/Export Options" button (Gear Icon) next to the save button and select "Load Set". The queued set will be loaded to the paper doll for transmog.
- Improved Sorting: Items can be sorted by Default, Alphabetical, Appearance, Item Source, Color*, Expansion, Item Level, or Item ID. Sets can be sorted by Default, Alphabetical, Expansion, or Collected Count. (*Color is sorted using the item's appearance file name, which is not always exact.)
- Color Filter: Pick an exact color from a color wheel and filter the item list down to appearances that are a close visual match - handy for finding a piece that matches the rest of your outfit. This is a filter, separate from the color sort option above.
- Hide Item Appearances and Sets: Right clicking on an item will give you the option to hide it from view. These settings are hooked to a character-based profile so you can quickly copy them among different characters or quickly reset the list. There is a toggle in the settings menu to have the UI show previously hidden items, which will have an icon indicating that they had been hidden.
- Collection Lists: You can create multiple lists in which you can select an appearance or a set to build up a list of appearances that you want to track. Once added to a list they can be easily viewed by clicking the "Collection List Book Icon" in the lower right corner of the Item Collection tab. Appearances in the Collection List have a small book icon and once the appearance is learned, a small check mark will be shown.
- "Shopping List": By <Shift> Clicking on the "Collection List Book Icon" a more detailed view of the Collection List is shown. This view displays all the items that unlock the selected appearance and info on how that item is obtained. If TradeSkillMaster is installed then the price for items are shown for Vendor, Profession and World Drop items when available. DBMarket is used as default, but additional TSM pricing can be set in the options.
- TSM Group Lists: From the "Shopping List" page you can generate a TSM group list that contains Vendor, Profession and World Drop items grouped by their appearance.
- Item Substitution: Substitute the item shown in a set for another. Just right click on the item in the set preview window or via the options page. Great for when an item is no longer in game, or if you think another item will look better.
- View other armor weight sets: See other types of armor by selecting it via the Filters Drop Down menu. *This is currently only available on the Extra Tab, the functionality for the default sets is currently in development.*
- View other class sets in the Extra Sets: Turn off the class filter in the options menu to see all armor for your class's armor type. Armor sets flagged for other classes will show up with a visual indicator and the class added to its name.

### Improved Transmog Vendor

- Unlimited Saved Outfits: Any sets over the max Blizzard default of 20 will now be automatically saved by the addon. This is integrated into the outfit list so there is nothing needed to be done by the user.
- Randomizer: Build a completely random set by clicking on the Randomizer button at the Transmog vendor. Alternatively you can have it randomly select a user saved outfit by <Shift> clicking the button. *Currently there is no way to ignore slots or randomize a specific slot, but these features are on the list to add in a future release.*
- Transmog Incomplete Sets: No more missing out on an outfit just because you're missing that one piece that never drops. Just set the max number of missing pieces allowed and any sets that match will be shown when visiting the Transmog vendor, additionally you can select slots to ignore when considering missing pieces. When at the Transmog vendor you can easily toggle between seeing the full set and the actual collected set pieces.
- "Combine Sets": When at the transmog vendor you can combine multiple sets to fill in missing appearances. To use, first select the initial appearance to use, then hold the <Shift> key and select any new set. The appearances from the second set will be used to fill in any missing pieces from the initial appearance. You can do this for as many sets until all appearance slots have been used. Great if you are missing a few pieces and want to fill them in with a similar appearance from a different raid type or with a lookalike set.
- Names & collected set piece count added to the transmog vendor view.
- Auto Hide Missing Transmog Slots: When transmoging an incomplete set you have the option to have any missing set pieces set to be hidden. (The exception is the pants slot, which does not have a hide option.)
- AutoHide Transmog Slots: A menu button has been added to the Transmog Vendor from which you can select slots which will always be set to the hidden appearance when selecting a set or extra set.
- Load Sets: Ability to quickly load a set queued from the Collection Journal without needing to find it again at the Transmog Vendor.
- Situations Presets: Save and re-apply named presets for Blizzard's own transmog "Situations" options (e.g. mounted, in combat) from the vendor's Situations tab, so you can switch between different conditional-transmog setups in one click instead of reconfiguring them each time.

### Enhanced Tooltips

- Tooltips have lines added to reflect Set, Extra Set & Wishlist items.
- Sets/Extra Set tooltip shows set completion, with options to list all the set items or just the unlearned pieces.
- View set pieces that tokens convert into.
- Appearance Preview: Hover an item to see a live 3D model preview of the appearance, with options for zoom (separately for items and weapons), rotating with the mouse, showing it on the dressing-room dummy vs. your current gear, and a resizable/movable preview window. *Off by default - enable it in the options.*
- Alt-appearance items also show a note in their tooltip when another source is available (see Alt-Appearance Detection above).

### Enhanced Dressing Room

- Resize and Move the Dressing Room.
- Auto hide Tabards, Shirts, Weapons and the Dressing Room Background on show.
- Item buttons showing the currently applied appearance. Left Click will toggle the appearance while a Right Click will clear the spot.
- Button to quickly undress the model.
- Import sets from WoWHead or MogIt.
- Export the current appearances using the same format as MogIt.
- Quick load previously queued sets from the Collection Journal.

### Addon Integrations

- MogIt Integration: Any MogIt sets will be automatically added to the outfits dropdown and the saved sets tab, and any MogIt wishlist items will have their own list in the Collection List dropdown.
- TransmogOutfits Integration: Any TransmogOutfits sets will be automatically added to the outfits dropdown and the saved sets tab.
- CanIMogIt Integration: If CanIMogIt is installed, its collected-ratio indicators are shown directly on BetterWardrobe's own set frames.
- ElvUI Integration: If ElvUI is installed, BetterWardrobe's tabs, dropdowns, buttons, scrollbars, and paging controls are automatically reskinned to match.
