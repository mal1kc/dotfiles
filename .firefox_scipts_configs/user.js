user_pref("accessibility.typeaheadfind.flashBar", 0);
user_pref("beacon.enabled", false);
user_pref(
    "browser.pageActions.persistedActions",
    '{"ids":["bookmark"],"idsInUrlbar":["bookmark"],"idsInUrlbarPreProton":[],"version":1}');
user_pref("browser.pagethumbnails.storage_version", 3);
user_pref(
    "browser.newtabpage.pinned",
    '[{"url":"https://www.youtube.com/","baseDomain":"youtube.com"},{"url":"https://github.com/","baseDomain":"github.com"},null,null,null,null,null,null]');
user_pref(
    "browser.policies.runOncePerModification.extensionsInstall",
    '["https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"]',
    '["https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi"]',
);
user_pref("browser.policies.runOncePerModification.setDefaultSearchEngine",
          "DuckDuckGo");
user_pref("dom.forms.autocomplete.formautofill", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);
user_pref("dom.security.https_only_mode_ever_enabled_pbm", true);
user_pref("dom.security.https_only_mode_pbm", true);
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
user_pref("general.autoScroll", true);
user_pref("identity.fxaccounts.enabled", true);
user_pref("identity.fxaccounts.toolbar.accessed", true);
user_pref("javascript.use_us_english_locale", true);
user_pref("media.eme.enabled", true);
user_pref("media.videocontrols.picture-in-picture.video-toggle.has-used", true);
user_pref(
    "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation",
    true);
user_pref("pdfjs.enabledCache.state", true);
user_pref("pref.downloads.disable_button.edit_actions", false);
user_pref("pref.privacy.disable_button.cookie_exceptions", false);
user_pref("privacy.annotate_channels.strict_list.enabled", true);
user_pref("privacy.history.custom", true);
user_pref("privacy.partition.network_state.ocsp_cache", true);
user_pref("privacy.query_stripping.enabled", true);
user_pref("privacy.query_stripping.enabled.pbmode", true);
user_pref("privacy.sanitize.sanitizeOnShutdown", false);
user_pref("privacy.spoof_english", 2);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
// new things
// disable native vertical-tabs tabs because userChrome.css
user_pref("sidebar.revamp", false);
user_pref("browser.toolbarbuttons.introduced.sidebar-button", true);
user_pref("browser.download.autohideButton", true);
user_pref("browser.tabs.firefox-view.ui-state.tab-pickup.open", true);
user_pref("browser.tabs.inTitlebar", 0);
user_pref("browser.tabs.loadBookmarksInTabs", true);
user_pref("browser.tabs.warnOnClose", true);
user_pref("browser.theme.content-theme", 0);
user_pref("browser.theme.toolbar-theme", 0);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.uiCustomization.state", {
  "placements" : {
    "widget-overflow-fixed-list" : [ "firefox-view-button" ],
    "unified-extensions-area" : [
      "_21f1ba12-47e1-4a9b-ad4e-3a0260bbeb26_-browser-action",
      "_7fc8ef53-24ec-4205-87a4-1e745953bb0d_-browser-action",
      "popupwindow_ettoolong-browser-action",
      "tab-session-manager_sienori-browser-action",
      "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"
    ],
    "nav-bar" : [
      "sidebar-button",
      "back-button",
      "forward-button",
      "vertical-spacer",
      "stop-reload-button",
      "urlbar-container",
      "screenshot-button",
      "downloads-button",
      "zoom-controls",
      "fxa-toolbar-menu-button",
      "ublock0_raymondhill_net-browser-action",
      "keepassxc-browser_keepassxc_org-browser-action",
      "_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action",
      "jid0-gjwrpchs3ugt7xydvqvk4dqk8ls_jetpack-browser-action",
      "extension_one-tab_com-browser-action",
      "_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action",
      "unified-extensions-button",
      "reset-pbm-toolbar-button",
      "_3c078156-979c-498b-8990-85f7987dd929_-browser-action"
    ],
    "toolbar-menubar" : [ "menubar-items" ],
    "TabsToolbar" : [ "new-tab-button", "tabbrowser-tabs", "alltabs-button" ],
    "vertical-tabs" : [],
    "PersonalToolbar" : [ "personal-bookmarks" ]
  },
  "seen" : [
    "developer-button",
    "ublock0_raymondhill_net-browser-action",
    "keepassxc-browser_keepassxc_org-browser-action",
    "_c2c003ee-bd69-42a2-b0e9-6f34222cb046_-browser-action",
    "jid0-gjwrpchs3ugt7xydvqvk4dqk8ls_jetpack-browser-action",
    "extension_one-tab_com-browser-action",
    "_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action",
    "_21f1ba12-47e1-4a9b-ad4e-3a0260bbeb26_-browser-action",
    "_7fc8ef53-24ec-4205-87a4-1e745953bb0d_-browser-action",
    "popupwindow_ettoolong-browser-action",
    "tab-session-manager_sienori-browser-action",
    "_3c078156-979c-498b-8990-85f7987dd929_-browser-action",
    "alltabs-button",
    "_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action"
  ],
  "dirtyAreaCache" : [
    "nav-bar", "PersonalToolbar", "toolbar-menubar", "TabsToolbar",
    "unified-extensions-area", "widget-overflow-fixed-list", "vertical-tabs"
  ],
  "currentVersion" : 21,
  "newElementCount" : 4
});
user_pref("browser.protections_panel.infoMessage.seen", true);
user_pref("browser.proton.toolbar.version", 3);
user_pref("browser.urlbar.placeholderName", "DuckDuckGo");
user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");
user_pref("widget.non-native-theme.scrollbar.style", 2);
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);
// OS text scaling settings should only affect text scaling
// (prevents blurring of icons)
user_pref("browser.display.os-zoom-behavior", 2);
user_pref("browser.urlbar.trimHttps", true);
user_pref("browser.urlbar.decodeURLsOnCopy", true)
// for better auto-hide of sideberry
user_pref("sidebar.revamp", true);
