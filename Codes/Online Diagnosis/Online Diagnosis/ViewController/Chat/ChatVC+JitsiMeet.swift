


 import JitsiMeetSDK

extension ChatVC  {
    
    
    @IBAction func onMeeting(_ sender: Any) {
        
        
        let chatID = self.chatID
        let room = chatID.replacingOccurrences(of: "[^a-zA-Z0-9]", with: "", options: .regularExpression)
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CallVC") as! CallVC
        vc.modalPresentationStyle = .fullScreen
       
        let options = JitsiMeetConferenceOptions.fromBuilder { builder in
            builder.serverURL = URL(string: "https://jitsi.member.fsf.org/")
            builder.room = room
            builder.setAudioOnly(true)
            builder.setVideoMuted(true)
            
            builder.setFeatureFlag(JITSI_CONSTANT.WELCOME_PAGE_ENABLED, withValue: false)
           // builder.welcomePageEnabled = false
            builder.setConfigOverride("requireDisplayName", withBoolean: true)
            builder.setConfigOverride(JITSI_CONSTANT.INVITE_ENABLED, withBoolean: false)
           
            
            
        }
        vc.options = options

        self.present(vc, animated: true)
        
    }
    
    
}




enum JITSI_CONSTANT {
    
    
    /**
         * Flag indicating if add-people functionality should be enabled.
         * Default: enabled (true).
         */
    static var ADD_PEOPLE_ENABLED = "add-people.enabled"

        /**
         * Flag indicating if the SDK should not require the audio focus.
         * Used by apps that do not use Jitsi audio.
         * Default: disabled (false).
         */
    static var AUDIO_FOCUS_DISABLED = "audio-focus.disabled"

        /**
         * Flag indicating if car mode should be enabled.
         * Default: enabled (true).
         */
    static var CAR_MODE_ENABLED = "car-mode.enabled"

        /**
         * Flag indicating if the audio mute button should be displayed.
         * Default: enabled (true).
         */
    static var AUDIO_MUTE_BUTTON_ENABLED = "audio-mute.enabled"

        /**
         * Flag indicating that the Audio only button in the overflow menu is enabled.
         * Default: enabled (true).
         */
    static var AUDIO_ONLY_BUTTON_ENABLED = "audio-only.enabled"

        /**
         * Flag indicating if calendar integration should be enabled.
         * Default: enabled (true) on Android, auto-detected on iOS.
         */
    static var CALENDAR_ENABLED = "calendar.enabled"

        /**
         * Flag indicating if call integration (CallKit on iOS, ConnectionService on Android)
         * should be enabled.
         * Default: enabled (true).
         */
    static var CALL_INTEGRATION_ENABLED = "call-integration.enabled"

        /**
         * Flag indicating if close captions should be enabled.
         * Default: enabled (true).
         */
    static var CLOSE_CAPTIONS_ENABLED = "close-captions.enabled"

        /**
         * Flag indicating if conference timer should be enabled.
         * Default: enabled (true).
         */
    static var CONFERENCE_TIMER_ENABLED = "conference-timer.enabled"

        /**
         * Flag indicating if chat should be enabled.
         * Default: enabled (true).
         */
    static var CHAT_ENABLED = "chat.enabled"

        /**
         * Flag indicating if the filmstrip should be enabled.
         * Default: enabled (true).
         */
    static var FILMSTRIP_ENABLED = "filmstrip.enabled"

        /**
         * Flag indicating if fullscreen (immersive) mode should be enabled.
         * Default: enabled (true).
         */
    static var FULLSCREEN_ENABLED = "fullscreen.enabled"

        /**
         * Flag indicating if the Help button should be enabled.
         * Default: enabled (true).
         */
    static var HELP_BUTTON_ENABLED = "help.enabled"

        /**
         * Flag indicating if invite functionality should be enabled.
         * Default: enabled (true).
         */
    static var INVITE_ENABLED = "invite.enabled"

        /**
         * Flag indicating if screen sharing should be enabled in android.
         * Default: enabled (true).
         */
    static var ANDROID_SCREENSHARING_ENABLED = "android.screensharing.enabled"
    
    /**
     * Flag indicating if recording should be enabled in iOS.
     * Default: disabled (false).
     */
    static var  IOS_RECORDING_ENABLED = "ios.recording.enabled"

    /**
     * Flag indicating if screen sharing should be enabled in iOS.
     * Default: disabled (false).
     */
    static var  IOS_SCREENSHARING_ENABLED = "ios.screensharing.enabled"
    
    /**
       * Flag indicating if the prejoin page should be enabled.
       * Default: enabled (true).
       */
    static var PREJOIN_PAGE_ENABLED = "prejoinpage.enabled"

        /**
         * Flag indicating if speaker statistics should be enabled.
         * Default: enabled (true).
         */
    static var SPEAKERSTATS_ENABLED = "speakerstats.enabled"

        /**
         * Flag indicating if kickout is enabled.
         * Default: enabled (true).
         */
    static var KICK_OUT_ENABLED = "kick-out.enabled"

        /**
         * Flag indicating if live-streaming should be enabled.
         * Default: auto-detected.
         */
    static var LIVE_STREAMING_ENABLED = "live-streaming.enabled"

        /**
         * Flag indicating if lobby mode button should be enabled.
         * Default: enabled.
         */
    static var LOBBY_MODE_ENABLED = "lobby-mode.enabled"

        /**
         * Flag indicating if displaying the meeting name should be enabled.
         * Default: enabled (true).
         */
    static var MEETING_NAME_ENABLED = "meeting-name.enabled"

        /**
         * Flag indicating if the meeting password button should be enabled.
         * Note that this flag just decides on the button, if a meeting has a password
         * set, the password dialog will still show up.
         * Default: enabled (true).
         */
    static var MEETING_PASSWORD_ENABLED = "meeting-password.enabled"

        /**
         * Flag indicating if the notifications should be enabled.
         * Default: enabled (true).
         */
    static var NOTIFICATIONS_ENABLED = "notifications.enabled"

        /**
         * Flag indicating if the audio overflow menu button should be displayed.
         * Default: enabled (true).
         */
    static var OVERFLOW_MENU_ENABLED = "overflow-menu.enabled"

        /**
         * Flag indicating if Picture-in-Picture should be enabled.
         * Default: auto-detected.
         */
    static var PIP_ENABLED = "pip.enabled"

        /**
         * Flag indicating if raise hand feature should be enabled.
         * Default: enabled.
         */
    static var RAISE_HAND_ENABLED = "raise-hand.enabled"

        /**
         * Flag indicating if the reactions feature should be enabled.
         * Default: enabled (true).
         */
    static var REACTIONS_ENABLED = "reactions.enabled"

        /**
         * Flag indicating if recording should be enabled.
         * Default: auto-detected.
         */
    static var RECORDING_ENABLED = "recording.enabled"

        /**
         * Flag indicating if the user should join the conference with the replaceParticipant functionality.
         * Default: (false).
         */
    static var REPLACE_PARTICIPANT = "replace.participant"

        /**
         * Flag indicating the local and (maximum) remote video resolution. Overrides
         * the server configuration.
         * Default: (unset).
         */
    static var RESOLUTION = "resolution"

        /**
         * Flag indicating if the security options button should be enabled.
         * Default: enabled (true).
         */
    static var SECURITY_OPTIONS_ENABLED = "security-options.enabled"

        /**
         * Flag indicating if server URL change is enabled.
         * Default: enabled (true).
         */
    static var SERVER_URL_CHANGE_ENABLED = "server-url-change.enabled"

        /**
         * Flag indicating if tile view feature should be enabled.
         * Default: enabled.
         */
    static var TILE_VIEW_ENABLED = "tile-view.enabled"

        /**
         * Flag indicating if the toolbox should be always be visible
         * Default: disabled (false).
         */
    static var TOOLBOX_ALWAYS_VISIBLE = "toolbox.alwaysVisible"

        /**
         * Flag indicating if the toolbox should be enabled
         * Default: enabled.
         */
    static var TOOLBOX_ENABLED = "toolbox.enabled"

        /**
         * Flag indicating if the video mute button should be displayed.
         * Default: enabled (true).
         */
    static var VIDEO_MUTE_BUTTON_ENABLED = "video-mute.enabled"

        /**
         * Flag indicating if the video share button should be enabled
         * Default: enabled (true).
         */
    static var VIDEO_SHARE_BUTTON_ENABLED = "video-share.enabled"
    
    /**
     * Flag indicating if settings should be enabled.
     * Default: enabled (true).
     */
    static var SETTINGS_ENABLED = "settings.enabled"

        /**
         * Flag indicating if the welcome page should be enabled.
         * Default: disabled (false).
         */
    static var WELCOME_PAGE_ENABLED = "welcomepage.enabled"
}


 
