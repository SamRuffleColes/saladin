class Strings {
  static const String appTitle = "Brush Tips";

  //signin and registration
  static const String googleSignIn = "Sign-in with Google";
  static const String signInErrorTitle = "Sign-in error";

  //menu
  static const String about = "About";
  static const String feedback = "Feedback";
  static const String signOut = "Sign Out";

  //about screen
  static const String aboutBody = "This app was built using the finest hand-knitted computer code, by Sam and Lara Ruffle Coles.\n\nFeedback welcomed.";
  static const String feedbackEmailAddress = "feedback@brushtips.co.uk";
  static const String openSourceLicences = "Open Source Licence Information";

  //guides screen
  static const String guidesScreenTitle = appTitle;
  static const String createNewGuide = "New Guide";

  //edit guide screen
  static const String editGuideScreenTitle = "Guide";
  static const String nameLabel = "Name";
  static const String nameValidationError = "Name field cannot be empty";
  static const String uploadingGuide = "Your guide is now uploading...";
  static const String errorUploadingGuide = "Something went wrong, please try again.";
  static const String submitGuideValidationErrors = "There are validation errors, please review before saving.";
  static const String selectImageFromDevice = "Select image from device";
  static const String addNewStep = "Add Step";
  static const String deleteConfirmationTitle = "Delete Guide";
  static const String deleteConfirmationBody =
      "Are you sure you want to delete this guide? This action can not be undone.";

  //edit step screen
  static const String editStepScreenTitle = "Step";
  static const String verbLabel = "Verb";
  static const String paintLabel = "Paint";
  static const String notesLabel = "Notes";
  static const String verbValidationError = "Verb field cannot be empty";
  static const List<String> stepVerbs = [
    "Drybrush",
    "Highlight",
    "Stipple",
    "Glue",
    "Varnish",
    "Dry blend",
    "Wet blend",
    "Glaze"
  ];
  static const String other = "Other";

  //paints screen
  static const String miniaturePaintsScreenTitle = "Paints";
  static const String chooseManufacturerFilters = "Filter by manufacturer";

  //general
  static const String unknown = "Unknown";
  static const String ok = "OK";
  static const String save = "Save";
  static const String change = "Change";
  static const String cancel = "Cancel";
  static const String delete = "Delete";
}
