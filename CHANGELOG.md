# Changelog
## What's changed.

### Wed Jul 8 2015
- Using the new [Login](https://github.com/NYULibraries/login/blob/development/CONTRACT.md) system
  - Throws away AuthLogic
  - Uses Devise and Omniauth
  - Discard the UserSession model and controller
  - Changes the current user model to remove AuthLogic specific fields and adds fields for Devise
  - Also does way with the `user_attributes` hash, now we just store information as extra data in the model
- Using new NYULibraries-assets - Gives us a brand new InstitutionsHelper
- Features that required login are now WIP. Some feature scenarios that are dependent on other scenarios are marked WIP as well
