class AppConstants {
  static const appTitle = 'BellyBuddy - Your Daily Food Guide';

  // Home screen
  static const homeAppBarTitle = 'My Packing Lists';
  static const emptyListsMessage = 'No lists yet. Tap + to create one!';
  static const newCategoryTitle = 'New Category';
  static const listNameLabel = 'List Name';
  static const listNameHint = 'e.g. Gym, Holiday';
  static const pickColorLabel = 'Pick a Color:';
  static const pickIconLabel = 'Pick an Icon:';
  static const cancel = 'Cancel';
  static const create = 'Create';
  static const deleteListTitle = 'Delete List?';
  static const deleteListConfirmPrefix = 'Are you sure you want to delete';
  static const delete = 'Delete';

  // Preferences keys
  static const prefPackingListData = 'packing_list_data';
  static const prefIsDarkMode = 'isDarkMode';

  // Default categories/items
  static const homeCategoryTitle = 'Home';
  static const universityCategoryTitle = 'University';
  static const itemKeys = 'Keys';
  static const itemWallet = 'Wallet';
  static const itemPhone = 'Phone';
  static const itemCharger = 'Charger';
  static const itemLaptop = 'Laptop';
  static const itemIdCard = 'ID Card';

  // Quotes
  static const quoteHome = 'Home is where your story begins.';
  static const quoteFlight = 'Adventure awaits above the clouds.';
  static const quoteTrain = 'Stay on track and enjoy the journey.';
  static const quoteCar = 'Roads were made for journeys, not destinations.';
  static const quoteHiking = 'Take only memories, leave only footprints.';
  static const quoteBeach = 'Salt in the air, sand in your hair.';
  static const quoteSchool = 'Learning is your passport to the future.';
  static const quoteFitness = 'One rep closer to your goal.';
  static const quoteWork = 'Pack smart, deliver sharp.';
  static const quoteMusic = 'Pack the vibes, not just the gear.';
  static const quoteCamera = 'Collect moments, not things.';
  static const quoteShopping = 'List it, pack it, enjoy it.';
  static const quotePets = "Don't forget the furry friend.";
  static const defaultQuote = 'Pack smart and travel light.';

  // Checklist screen
  static const addNewItemTitle = 'Add New Item';
  static const addNewItemHint = 'Item name (e.g. Towel)';
  static const renameListTitle = 'Rename List';
  static const save = 'Save';
  static const listResetMessage = 'List reset!';
  static const tapItemsToDelete = 'Tap items to delete';
  static const listEmptyMessage = 'List is empty.';
  static const addItem = 'Add Item';
  static const resetList = 'Reset List';

  static const itemsPackedLabel = 'items packed';
  static String itemsPackedText(int checked, int total) =>
      '$checked / $total $itemsPackedLabel';

  static String deleteListConfirmText(String listTitle) =>
      "$deleteListConfirmPrefix '$listTitle'?";
}
