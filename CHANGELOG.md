# 5.14.3-12.0.7-12.1.0.33-native-dev

- Repackaged `.32-native-dev` with a mandatory clean-replacement installer after legacy ExtendedSets files were reported loading from the installed BetterWardrobe folder.
- The installer now deletes the existing `Interface\AddOns\BetterWardrobe` directory before copying the native-dev package, preventing stale `WeaponSets\ExtendedSetsDB`, `SL.lua`, `ArmorFinalize.lua`, and other production-tree files from remaining.
- Installation verification now confirms the `.33-native-dev` TOC version and fails if the legacy `WeaponSets\ExtendedSetsDB` directory is still present.
- Addon Lua, catalog data, color filtering, sorting, native wardrobe integration, and options are unchanged from `.32-native-dev`.

# 5.14.3-12.0.7-12.1.0.32-native-dev

- Fixed the Items/Appearances sort selection being saved without changing the live displayed order.
- Hooks the actual Collections Items frame after Blizzard has copied its mixin methods.
- Applies the same Items sort state to the actual transmogrifier PagedContent provider.
- Added the BetterWardrobe Sort submenu to `MENU_TRANSMOG_ITEMS_FILTER`.
- Name, Expansion, Appearance ID, Collection status, and Reverse order now reapply after searches, category changes, catalog refreshes, and color filtering.
- Resetting either native Items filter button now also restores BetterWardrobe item sorting to Default.
- Avoids Blizzard's warning-producing sorted-source helper when resolving sort metadata for supplemental visuals.
- No Items/Appearances expansion filter was restored; Expansion remains a sorting mode only.

# 5.14.3-12.0.7-12.1.0.31-native-dev

- Fixed the production color swatch updating visually without limiting the Items/Appearances results.
- Hooks the actual live Collections Items frame instead of the mixin table copied during Blizzard XML initialization.
- Hooks the actual live transmogrifier Items frame and republishes the filtered entries through Blizzard's native PagedContent provider.
- Keeps the color predicate active across native refreshes, searches, category changes, catalog augmentation, and collection updates until Reset or frame close.
- Retains the production ColorTable, CIE-LAB conversion, Delta E94 comparison, and tolerance of 17.
- No expansion filter was reintroduced for Items/Appearances.

# 5.14.3-12.0.7-12.1.0.30-native-dev

- Based directly on `.23-native-dev`; no `.24`-`.29` appearance-expansion changes were carried forward.
- Removed the added Expansion and menu-based Color entries from Items/Appearances.
- Kept Blizzard's native collected, uncollected, faction, race, and source-type API filters unchanged.
- Retained BetterWardrobe's item sorting menu without treating sorting as an appearance filter.
- Restored the production standalone color-swatch button and revert button for Items/Appearances.
- Ported the production CIE-LAB conversion, Delta E94 comparison, sampled `ColorTable` palette, and tolerance of 17.
- Added the same production color control to the actual transmogrifier Items/Appearances frame.
- Color selection is transient like production and resets when the Items frame closes.
- Added a one-time migration that clears the retired saved Items expansion/menu-color values.

# 5.14.3-12.0.7-12.1.0.23-native-dev

- Restored the visible production-style `Apply On Click` checkbox in Blizzard's actual transmogrifier wardrobe.
- The checkbox is synchronized with the BetterWardrobe Settings option and controls automatic application for Extra Sets, recolor changes, weapon rows, and weapon source icons.
- Retained explicit `Apply Set` and `Apply Weapon` buttons when automatic application is disabled.
- Restored the working production option groups on the main BetterWardrobe Settings page: General, Transmog Vendor Window, and Dressing Room.
- Restored transmog toggles for incomplete/hidden sets, missing pieces, hidden replacements, required piece count, set names, and collected counts.
- Restored Dressing Room toggles for enablement, background dim/hide, undressed start, hidden weapons/shirt/tabard, custom sizing, width, and height.
- Added one-time migration from the production `BetterWardrobe_Options` profile, including `AutoApply`, without overwriting existing native-dev values.
- Kept the Extra Sets and Weapons tabs in the actual transmogrifier and preserved the 600 x 800 Dressing Room default.
- Removed an accidental nested Extra Sets cache loop during collection refresh.

# 5.14.3-12.0.7-12.1.0.22-native-dev

- Changed the default custom Dressing Room size from 700 x 700 to 600 x 800.
- Added a one-time migration that updates the previous 700 x 700 native-dev default while preserving any other user-selected dimensions.
- Updated the native Settings slider defaults to 600 px width and 800 px height.
- Retained the Extra Sets and Weapons tabs in the actual transmogrifier window, including click-to-apply.
- Added an OnShow retry so those transmogrifier tabs are registered even when Blizzard initializes its wardrobe content later than the addon-load event.
- Catalog coverage, collection filters, and sorting remain unchanged.

# 5.14.3-12.0.7-12.1.0.21-native-dev

- Restored the production BetterWardrobe click-to-apply path at the transmogrifier.
- Added Extra Sets and Weapons tabs to Blizzard's native transmogrifier wardrobe without replacing the native Items, Sets, or Custom Sets frames.
- Ported the production `UpdateOutfit` / `ApplyOutfit` slot mapping so clicking an Extra Set creates the complete pending armor outfit in one action.
- Clicking a Weapons row applies its active source to the selected weapon slot; clicking another weapon icon immediately changes the pending source.
- Recolor selection in the transmogrifier reapplies the newly selected Extra Set or weapon variant.
- Native Items and Sets retain Blizzard's existing click-to-apply implementation.
- The Collections Journal behavior, complete catalog merge, filters, sorting, audit, and installer remain unchanged.

# 5.14.3-12.0.7-12.1.0.20-native-dev

- Corrected `/bw audit` base-group coverage for API groups that Blizzard represents with a variant record instead of a standalone base record.
- Provider coverage now indexes each row by its canonical `baseSetID`, falling back to `C_TransmogSets.GetBaseSetID(setID)` when needed.
- The four groups previously reported as missing (`5350`-`5353`) are now counted through their representative variant rows rather than treated as absent.
- Added an informational audit note listing representative base-to-variant mappings; these rows are coverage aliases, not missing catalog records.
- No transmog catalog data, filters, or display lists were removed or reduced.

# 5.14.3-12.0.7-12.1.0.19-native-dev

- Corrected `/bw audit` reporting inactive Items and Sets frames as empty underlying providers.
- Added an isolated Blizzard `WardrobeSetsDataProviderMixin` instance for deterministic native Sets coverage checks without opening or switching tabs.
- The audit no longer replaces the real native Sets provider reference with its temporary coverage provider.
- API armor base-set coverage is now checked against the fully merged provider even when the Sets tab is inactive.
- The audit no longer forces inactive Items or Sets frames through their display refresh paths.
- Bundled Items coverage is now reported globally by resolved visual and category totals; current-tab counts are shown only when Blizzard initialized that view.
- Extra Sets audit totals are labeled as the current character's class-eligible records rather than being compared incorrectly with all five armor databases.
- Expanded filter-integrity checks to include grouped variant counts and the isolated native Sets provider size.

# 5.14.3-12.0.7-12.1.0.18-native-dev

- Fixed `/bw audit` calling Blizzard `FilterVisuals()` while the inactive Items tab had no initialized `visualsList`.
- Items display refresh is now skipped safely until Blizzard's Items provider exists; the underlying catalog count is still audited.
- The staged audit now stops its OnUpdate driver before finalization so a provider failure cannot repeat every frame.
- Added a guarded audit abort path that reports one concise error instead of generating repeated Lua errors.

# 5.14.3-12.0.7-12.1.0.17-native-dev

- Added a staged runtime catalog audit under `/bw audit` so all bundled source IDs are checked without a single long frame-time spike.
- The audit reports resolved and pending/restricted sources, unique visuals, category coverage, current Items/Sets display counts, Extra Sets and Weapons grouping totals, and missing API armor base sets.
- Added a filter-integrity check that refreshes each tab and verifies the underlying Items, Sets, Extra Sets, Weapons, and static catalog counts remain unchanged.
- Corrected supplemental Items so the full category union is retained in the underlying list; collected, uncollected, search, expansion, and color rules are applied only to the displayed results.
- Corrected supplemental Sets so the complete armor base-set union remains cached; native and BetterWardrobe filters now operate on a separate ScrollBox display list instead of deleting records from the provider cache.
- Preserved Blizzard's native wardrobe frames, list templates, model APIs, cameras, tooltips, and selection behavior.

# 5.14.3-12.0.7-12.1.0.16-native-dev

- Restored the original BetterWardrobe supplemental transmog catalog on top of Blizzard's native Items and Sets providers.
- Restored the complete original Extra Sets records, including explicit alternate appearances that were lost when duplicate slot keys were flattened.
- Restored the original set overrides, miscellaneous set classifications, artifact appearance catalog, and appearance-file metadata.
- Native Items now union Blizzard category results with missing Extra Set, Weapon Set, artifact, and alternate appearance sources, deduplicated by visual ID.
- Native Sets now union Blizzard's base-set provider with armor sets from `C_TransmogSets.GetAllSets()`, including normally hidden supplemental variants while keeping weapon-only artifact groups out of the armor list.
- Added `/bw catalog` and `/bw audit` to print the runtime catalog summary.
- Filters remain display filters and do not remove records from the underlying catalog.
- Retained the native Blizzard frames, model APIs, cameras, search, tooltips, and collection state.

# 5.14.3-12.0.7-12.1.0.13-native-dev

- Replaced the PowerShell-based installer with a single native CMD/Robocopy installer.
- Added Smart App Control instructions to unblock the ZIP before extraction.
- Added a no-script terminal-copy fallback for systems that continue to block downloaded scripts.
- World of Warcraft may remain open; run `/reload` after installation.

# 5.14.3-12.0.7-12.1.0.12-native-dev

- Updated the Windows installer to support live installation while World of Warcraft is running.
- Installer now mirrors the bundled addon into Retail AddOns and removes obsolete files.
- After installation, only `/reload` is required in game.
- This live installer format is the standard for future addon development ZIPs.

# 5.14.3-12.0.7-12.1.0.11-native-dev

- Added a one-click Windows installer at the ZIP root.
- Installer targets `D:\\Games\\World of Warcraft\\_retail_\\Interface\\AddOns`.
- Verifies the bundled addon, requires WoW to be closed, deletes the previous BetterWardrobe folder, installs the new build, and verifies the TOC.

# 5.14.3-12.0.7-12.1.0.10-native-dev

- Auto-sized the wardrobe tabs to their labels.
- Renamed Weapon Sets to Weapons.
- Moved the native collection progress bar to the right of the tab row.

# 5.14.3-12.0.7-12.1.0.9-native-dev

- Reworked Extra Sets and Weapon Sets to match Blizzard Sets panel proportions and spacing.
- Uses Blizzard's native set-list row template for the custom collection lists.
- Moved the recolor dropdown to Blizzard's native top-right detail position.
- Matched the native set title, label, item-row, model, and dressing-room-button layout.
- Corrected the vertical text alignment of the Extra Sets and Weapon Sets tabs, including ElvUI skins.

# 5.14.3-12.0.7-12.1.0.8-native-dev

- Grouped Extra Sets recolors into one parent set row.
- Grouped Weapon Sets recolors into one parent set row.
- Added a native-style variant dropdown in the detail panel for selecting each color.
- Preserves the selected color independently for each parent set.
- Variant menu entries include collection counts and a color swatch when appearance color data is available.
- Added ElvUI skin handling for the new variant dropdown.

# 5.14.3-12.0.7-12.1.0.2-native-dev

- Added Extra Sets as an additive tab on Blizzard's native Appearances frame.
- Added Weapon Sets as an additive tab using the curated BetterWardrobe weapon-set database.
- Added sorting controls for Blizzard Items and Sets plus the Extra Sets and Weapon Sets panels.
- Kept Blizzard item models, set models, form selection, cameras, tooltips, search, and collection APIs as the underlying implementation.
- Kept the addon in one BetterWardrobe folder.
- Retail interfaces remain 120007 and 120100.

# BetterWardrobe Native Foundation

## 5.14.3-12.0.7-12.1.0.1-native-dev

- Reset to the BetterWardrobe 5.14.3 production release as the source baseline.
- Updated the Retail interface metadata to `120007, 120100`.
- Removed BetterWardrobe's replacement Appearances, Items, Sets, transmog, tooltip-model, and dressing-room frame implementations from the load path.
- Uses Blizzard's native `WardrobeCollectionFrame`, item and set collection frames, model mixins, form handling, cameras, search, filters, and tooltips.
- Keeps custom Dressing Room width and height as an additive setting applied to Blizzard's `DressUpFrame`.
- Uses Blizzard's native Settings interface instead of an addon-owned options frame.
- Consolidated to one `BetterWardrobe` addon folder.
- Retained `AppearanceData.lua` and `ColorData.lua` in the main folder for future additive features; they are not loaded by this foundation build.
- Removed the unused legacy `SourceData.lua` database.
