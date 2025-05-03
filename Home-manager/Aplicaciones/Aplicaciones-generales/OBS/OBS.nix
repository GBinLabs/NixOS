{pkgs, ...}: {
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-mute-filter
    ];
  };

  xdg.configFile."obs-studio/basic/profiles/YouTube/basic.ini" = {
    text = ''
        	[General]
      Name=YouTube

      [Output]
      Mode=Advanced
      FilenameFormatting=%CCYY-%MM-%DD %hh-%mm-%ss
      DelayEnable=false
      DelaySec=20
      DelayPreserve=true
      Reconnect=true
      RetryDelay=2
      MaxRetries=25
      BindIP=default
      IPFamily=IPv4+IPv6
      NewSocketLoopEnable=false
      LowLatencyEnable=false

      [Stream1]
      IgnoreRecommended=false
      EnableMultitrackVideo=false
      MultitrackVideoMaximumAggregateBitrateAuto=true
      MultitrackVideoMaximumVideoTracksAuto=true

      [SimpleOutput]
      FilePath=/home/german
      RecFormat2=mkv
      VBitrate=2500
      ABitrate=160
      UseAdvanced=false
      Preset=veryfast
      NVENCPreset2=p5
      RecQuality=Small
      RecRB=false
      RecRBTime=20
      RecRBSize=512
      RecRBPrefix=Replay
      StreamAudioEncoder=aac
      RecAudioEncoder=aac
      RecTracks=1
      StreamEncoder=x264
      RecEncoder=x264

      [AdvOut]
      ApplyServiceSettings=true
      UseRescale=false
      TrackIndex=1
      VodTrackIndex=2
      Encoder=obs_x264
      RecType=Standard
      RecFilePath=/home/german/Videos
      RecFormat2=mkv
      RecUseRescale=false
      RecTracks=7
      RecEncoder=hevc_ffmpeg_vaapi_tex
      FLVTrack=1
      StreamMultiTrackAudioMixes=1
      FFOutputToFile=true
      FFFilePath=/home/german
      FFVBitrate=2500
      FFVGOPSize=250
      FFUseRescale=false
      FFIgnoreCompat=false
      FFABitrate=160
      FFAudioMixes=1
      Track1Bitrate=160
      Track2Bitrate=160
      Track3Bitrate=160
      Track4Bitrate=160
      Track5Bitrate=160
      Track6Bitrate=160
      RecSplitFileTime=15
      RecSplitFileSize=2048
      RecRB=false
      RecRBTime=20
      RecRBSize=512
      AudioEncoder=libfdk_aac
      RecAudioEncoder=libfdk_aac
      RecSplitFileType=Time
      FFFormat=
      FFFormatMimeType=
      FFVEncoderId=0
      FFVEncoder=
      FFAEncoderId=0
      FFAEncoder=
      RecSplitFile=false
      FFExtension=mp4

      [Video]
      BaseCX=1920
      BaseCY=1080
      OutputCX=1920
      OutputCY=1080
      FPSType=0
      FPSCommon=60
      FPSInt=30
      FPSNum=30
      FPSDen=1
      ScaleType=bicubic
      ColorFormat=NV12
      ColorSpace=709
      ColorRange=Partial
      SdrWhiteLevel=300
      HdrNominalPeakLevel=1000

      [Audio]
      MonitoringDeviceId=default
      MonitoringDeviceName=Por defecto
      SampleRate=48000
      ChannelSetup=Stereo
      MeterDecayRate=23.53
      PeakMeterType=0

      [Panels]
      CookieId=69BB2760F92F642D
    '';
  };

  xdg.configFile."obs-studio/basic/profiles/YouTube/recordEncoder.json" = {
    text = ''
      {"vaapi_device":"/dev/dri/by-path/pci-0000:2b:00.0-render","rate_control":"CQP","qp":20,"keyint_sec":2}
    '';
  };

  xdg.configFile."obs-studio/basic/scenes/Sin_Título.json" = {
    text = ''
        	{
          "DesktopAudioDevice1": {
              "prev_ver": 520093699,
              "name": "Audio del escritorio",
              "uuid": "4ccc0ba9-cdc2-4a0a-a4d1-47acea4eec5f",
              "id": "pulse_output_capture",
              "versioned_id": "pulse_output_capture",
              "settings": {
                  "device_id": "default"
              },
              "mixers": 195,
              "sync": 0,
              "flags": 0,
              "volume": 1.0,
              "balance": 0.5,
              "enabled": true,
              "muted": true,
              "push-to-mute": false,
              "push-to-mute-delay": 0,
              "push-to-talk": false,
              "push-to-talk-delay": 0,
              "hotkeys": {
                  "libobs.mute": [],
                  "libobs.unmute": [],
                  "libobs.push-to-mute": [],
                  "libobs.push-to-talk": []
              },
              "deinterlace_mode": 0,
              "deinterlace_field_order": 0,
              "monitoring_type": 0,
              "private_settings": {}
          },
          "AuxAudioDevice1": {
              "prev_ver": 520093699,
              "name": "Mic/Aux",
              "uuid": "85f1eaa6-abd9-477c-a127-0b1077b10a20",
              "id": "pulse_input_capture",
              "versioned_id": "pulse_input_capture",
              "settings": {
                  "device_id": "default"
              },
              "mixers": 201,
              "sync": 0,
              "flags": 0,
              "volume": 1.0,
              "balance": 0.5,
              "enabled": true,
              "muted": true,
              "push-to-mute": false,
              "push-to-mute-delay": 0,
              "push-to-talk": false,
              "push-to-talk-delay": 0,
              "hotkeys": {
                  "libobs.mute": [],
                  "libobs.unmute": [],
                  "libobs.push-to-mute": [],
                  "libobs.push-to-talk": []
              },
              "deinterlace_mode": 0,
              "deinterlace_field_order": 0,
              "monitoring_type": 0,
              "private_settings": {}
          },
          "current_scene": "Counter - Strike 2",
          "current_program_scene": "Counter - Strike 2",
          "scene_order": [
              {
                  "name": "Counter - Strike 2"
              },
              {
                  "name": "Juegos"
              },
              {
                  "name": "Kovaak"
              }
          ],
          "name": "Sin Título",
          "sources": [
              {
                  "prev_ver": 520093699,
                  "name": "Counter - Strike 2",
                  "uuid": "73651ead-5475-45a9-8ebb-6e7b47d5393a",
                  "id": "scene",
                  "versioned_id": "scene",
                  "settings": {
                      "id_counter": 3,
                      "custom_size": false,
                      "items": [
                          {
                              "name": "Counter - Strike 2 Sonido",
                              "source_uuid": "e95dd188-ba27-4e05-8975-56bfce2e6e18",
                              "visible": true,
                              "locked": false,
                              "rot": 0.0,
                              "scale_ref": {
                                  "x": 1920.0,
                                  "y": 1080.0
                              },
                              "align": 5,
                              "bounds_type": 0,
                              "bounds_align": 0,
                              "bounds_crop": false,
                              "crop_left": 0,
                              "crop_top": 0,
                              "crop_right": 0,
                              "crop_bottom": 0,
                              "id": 2,
                              "group_item_backup": false,
                              "pos": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "pos_rel": {
                                  "x": -1.7777777910232544,
                                  "y": -1.0
                              },
                              "scale": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "scale_rel": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "bounds": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "bounds_rel": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "scale_filter": "disable",
                              "blend_method": "default",
                              "blend_type": "normal",
                              "show_transition": {
                                  "duration": 0
                              },
                              "hide_transition": {
                                  "duration": 0
                              },
                              "private_settings": {}
                          },
                          {
                              "name": "Counter - Strike 2 Video",
                              "source_uuid": "239574ee-d75d-45f0-9193-c2f097ebc37a",
                              "visible": true,
                              "locked": false,
                              "rot": 0.0,
                              "scale_ref": {
                                  "x": 1920.0,
                                  "y": 1080.0
                              },
                              "align": 5,
                              "bounds_type": 0,
                              "bounds_align": 0,
                              "bounds_crop": false,
                              "crop_left": 0,
                              "crop_top": 0,
                              "crop_right": 0,
                              "crop_bottom": 0,
                              "id": 3,
                              "group_item_backup": false,
                              "pos": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "pos_rel": {
                                  "x": -1.7777777910232544,
                                  "y": -1.0
                              },
                              "scale": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "scale_rel": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "bounds": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "bounds_rel": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "scale_filter": "disable",
                              "blend_method": "default",
                              "blend_type": "normal",
                              "show_transition": {
                                  "duration": 0
                              },
                              "hide_transition": {
                                  "duration": 0
                              },
                              "private_settings": {}
                          }
                      ]
                  },
                  "mixers": 0,
                  "sync": 0,
                  "flags": 0,
                  "volume": 1.0,
                  "balance": 0.5,
                  "enabled": true,
                  "muted": false,
                  "push-to-mute": false,
                  "push-to-mute-delay": 0,
                  "push-to-talk": false,
                  "push-to-talk-delay": 0,
                  "hotkeys": {
                      "OBSBasic.SelectScene": [],
                      "libobs.show_scene_item.2": [],
                      "libobs.hide_scene_item.2": [],
                      "libobs.show_scene_item.3": [],
                      "libobs.hide_scene_item.3": []
                  },
                  "deinterlace_mode": 0,
                  "deinterlace_field_order": 0,
                  "monitoring_type": 0,
                  "private_settings": {}
              },
              {
                  "prev_ver": 520093699,
                  "name": "Counter - Strike 2 Sonido",
                  "uuid": "e95dd188-ba27-4e05-8975-56bfce2e6e18",
                  "id": "pipewire_audio_application_capture",
                  "versioned_id": "pipewire_audio_application_capture",
                  "settings": {
                      "AppToAdd": ".obs-wrapped",
                      "TargetName": "cs2",
                      "CaptureMode": 0
                  },
                  "mixers": 197,
                  "sync": 0,
                  "flags": 0,
                  "volume": 1.0,
                  "balance": 0.5,
                  "enabled": true,
                  "muted": false,
                  "push-to-mute": false,
                  "push-to-mute-delay": 0,
                  "push-to-talk": false,
                  "push-to-talk-delay": 0,
                  "hotkeys": {
                      "libobs.mute": [],
                      "libobs.unmute": [],
                      "libobs.push-to-mute": [],
                      "libobs.push-to-talk": []
                  },
                  "deinterlace_mode": 0,
                  "deinterlace_field_order": 0,
                  "monitoring_type": 0,
                  "private_settings": {}
              },
              {
                  "prev_ver": 520093699,
                  "name": "Counter - Strike 2 Video",
                  "uuid": "239574ee-d75d-45f0-9193-c2f097ebc37a",
                  "id": "pipewire-screen-capture-source",
                  "versioned_id": "pipewire-screen-capture-source",
                  "settings": {
                      "RestoreToken": ""
                  },
                  "mixers": 0,
                  "sync": 0,
                  "flags": 0,
                  "volume": 1.0,
                  "balance": 0.5,
                  "enabled": true,
                  "muted": false,
                  "push-to-mute": false,
                  "push-to-mute-delay": 0,
                  "push-to-talk": false,
                  "push-to-talk-delay": 0,
                  "hotkeys": {},
                  "deinterlace_mode": 0,
                  "deinterlace_field_order": 0,
                  "monitoring_type": 0,
                  "private_settings": {}
              },
              {
                  "prev_ver": 520093699,
                  "name": "Kovaak",
                  "uuid": "c03da50c-ede5-4441-b5d9-37c7e359b233",
                  "id": "scene",
                  "versioned_id": "scene",
                  "settings": {
                      "id_counter": 2,
                      "custom_size": false,
                      "items": [
                          {
                              "name": "Kovaak - Video",
                              "source_uuid": "659e72d9-ae2c-4e4a-a103-e350b532bc55",
                              "visible": true,
                              "locked": false,
                              "rot": 0.0,
                              "scale_ref": {
                                  "x": 1920.0,
                                  "y": 1080.0
                              },
                              "align": 5,
                              "bounds_type": 0,
                              "bounds_align": 0,
                              "bounds_crop": false,
                              "crop_left": 0,
                              "crop_top": 0,
                              "crop_right": 0,
                              "crop_bottom": 0,
                              "id": 1,
                              "group_item_backup": false,
                              "pos": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "pos_rel": {
                                  "x": -1.7777777910232544,
                                  "y": -1.0
                              },
                              "scale": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "scale_rel": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "bounds": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "bounds_rel": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "scale_filter": "disable",
                              "blend_method": "default",
                              "blend_type": "normal",
                              "show_transition": {
                                  "duration": 0
                              },
                              "hide_transition": {
                                  "duration": 0
                              },
                              "private_settings": {}
                          },
                          {
                              "name": "Kovaak - Audio",
                              "source_uuid": "310e5d79-8b99-4a87-b301-e8afe5a63570",
                              "visible": true,
                              "locked": false,
                              "rot": 0.0,
                              "scale_ref": {
                                  "x": 1920.0,
                                  "y": 1080.0
                              },
                              "align": 5,
                              "bounds_type": 0,
                              "bounds_align": 0,
                              "bounds_crop": false,
                              "crop_left": 0,
                              "crop_top": 0,
                              "crop_right": 0,
                              "crop_bottom": 0,
                              "id": 2,
                              "group_item_backup": false,
                              "pos": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "pos_rel": {
                                  "x": -1.7777777910232544,
                                  "y": -1.0
                              },
                              "scale": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "scale_rel": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "bounds": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "bounds_rel": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "scale_filter": "disable",
                              "blend_method": "default",
                              "blend_type": "normal",
                              "show_transition": {
                                  "duration": 0
                              },
                              "hide_transition": {
                                  "duration": 0
                              },
                              "private_settings": {}
                          }
                      ]
                  },
                  "mixers": 0,
                  "sync": 0,
                  "flags": 0,
                  "volume": 1.0,
                  "balance": 0.5,
                  "enabled": true,
                  "muted": false,
                  "push-to-mute": false,
                  "push-to-mute-delay": 0,
                  "push-to-talk": false,
                  "push-to-talk-delay": 0,
                  "hotkeys": {
                      "OBSBasic.SelectScene": [],
                      "libobs.show_scene_item.1": [],
                      "libobs.hide_scene_item.1": [],
                      "libobs.show_scene_item.2": [],
                      "libobs.hide_scene_item.2": []
                  },
                  "deinterlace_mode": 0,
                  "deinterlace_field_order": 0,
                  "monitoring_type": 0,
                  "private_settings": {}
              },
              {
                  "prev_ver": 520093699,
                  "name": "Kovaak - Video",
                  "uuid": "659e72d9-ae2c-4e4a-a103-e350b532bc55",
                  "id": "pipewire-screen-capture-source",
                  "versioned_id": "pipewire-screen-capture-source",
                  "settings": {
                      "RestoreToken": ""
                  },
                  "mixers": 0,
                  "sync": 0,
                  "flags": 0,
                  "volume": 1.0,
                  "balance": 0.5,
                  "enabled": true,
                  "muted": false,
                  "push-to-mute": false,
                  "push-to-mute-delay": 0,
                  "push-to-talk": false,
                  "push-to-talk-delay": 0,
                  "hotkeys": {},
                  "deinterlace_mode": 0,
                  "deinterlace_field_order": 0,
                  "monitoring_type": 0,
                  "private_settings": {}
              },
              {
                  "prev_ver": 520093699,
                  "name": "Kovaak - Audio",
                  "uuid": "310e5d79-8b99-4a87-b301-e8afe5a63570",
                  "id": "pipewire_audio_application_capture",
                  "versioned_id": "pipewire_audio_application_capture",
                  "settings": {},
                  "mixers": 197,
                  "sync": 0,
                  "flags": 0,
                  "volume": 1.0,
                  "balance": 0.5,
                  "enabled": true,
                  "muted": false,
                  "push-to-mute": false,
                  "push-to-mute-delay": 0,
                  "push-to-talk": false,
                  "push-to-talk-delay": 0,
                  "hotkeys": {
                      "libobs.mute": [],
                      "libobs.unmute": [],
                      "libobs.push-to-mute": [],
                      "libobs.push-to-talk": []
                  },
                  "deinterlace_mode": 0,
                  "deinterlace_field_order": 0,
                  "monitoring_type": 0,
                  "private_settings": {}
              },
              {
                  "prev_ver": 520093699,
                  "name": "Juegos",
                  "uuid": "1bcc7208-efc2-4a0a-a250-9d0308369ac7",
                  "id": "scene",
                  "versioned_id": "scene",
                  "settings": {
                      "id_counter": 2,
                      "custom_size": false,
                      "items": [
                          {
                              "name": "Juegos - Video",
                              "source_uuid": "d420309e-af99-4ffc-baa0-375c81d71b55",
                              "visible": true,
                              "locked": false,
                              "rot": 0.0,
                              "scale_ref": {
                                  "x": 1920.0,
                                  "y": 1080.0
                              },
                              "align": 5,
                              "bounds_type": 0,
                              "bounds_align": 0,
                              "bounds_crop": false,
                              "crop_left": 0,
                              "crop_top": 0,
                              "crop_right": 0,
                              "crop_bottom": 0,
                              "id": 1,
                              "group_item_backup": false,
                              "pos": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "pos_rel": {
                                  "x": -1.7777777910232544,
                                  "y": -1.0
                              },
                              "scale": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "scale_rel": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "bounds": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "bounds_rel": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "scale_filter": "disable",
                              "blend_method": "default",
                              "blend_type": "normal",
                              "show_transition": {
                                  "duration": 0
                              },
                              "hide_transition": {
                                  "duration": 0
                              },
                              "private_settings": {}
                          },
                          {
                              "name": "Juegos - Audio",
                              "source_uuid": "33fbe49e-c23f-4f8c-af7e-407019801b28",
                              "visible": true,
                              "locked": false,
                              "rot": 0.0,
                              "scale_ref": {
                                  "x": 1920.0,
                                  "y": 1080.0
                              },
                              "align": 5,
                              "bounds_type": 0,
                              "bounds_align": 0,
                              "bounds_crop": false,
                              "crop_left": 0,
                              "crop_top": 0,
                              "crop_right": 0,
                              "crop_bottom": 0,
                              "id": 2,
                              "group_item_backup": false,
                              "pos": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "pos_rel": {
                                  "x": -1.7777777910232544,
                                  "y": -1.0
                              },
                              "scale": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "scale_rel": {
                                  "x": 1.0,
                                  "y": 1.0
                              },
                              "bounds": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "bounds_rel": {
                                  "x": 0.0,
                                  "y": 0.0
                              },
                              "scale_filter": "disable",
                              "blend_method": "default",
                              "blend_type": "normal",
                              "show_transition": {
                                  "duration": 0
                              },
                              "hide_transition": {
                                  "duration": 0
                              },
                              "private_settings": {}
                          }
                      ]
                  },
                  "mixers": 0,
                  "sync": 0,
                  "flags": 0,
                  "volume": 1.0,
                  "balance": 0.5,
                  "enabled": true,
                  "muted": false,
                  "push-to-mute": false,
                  "push-to-mute-delay": 0,
                  "push-to-talk": false,
                  "push-to-talk-delay": 0,
                  "hotkeys": {
                      "OBSBasic.SelectScene": [],
                      "libobs.show_scene_item.1": [],
                      "libobs.hide_scene_item.1": [],
                      "libobs.show_scene_item.2": [],
                      "libobs.hide_scene_item.2": []
                  },
                  "deinterlace_mode": 0,
                  "deinterlace_field_order": 0,
                  "monitoring_type": 0,
                  "private_settings": {}
              },
              {
                  "prev_ver": 520093699,
                  "name": "Juegos - Video",
                  "uuid": "d420309e-af99-4ffc-baa0-375c81d71b55",
                  "id": "pipewire-screen-capture-source",
                  "versioned_id": "pipewire-screen-capture-source",
                  "settings": {
                      "RestoreToken": ""
                  },
                  "mixers": 0,
                  "sync": 0,
                  "flags": 0,
                  "volume": 1.0,
                  "balance": 0.5,
                  "enabled": true,
                  "muted": false,
                  "push-to-mute": false,
                  "push-to-mute-delay": 0,
                  "push-to-talk": false,
                  "push-to-talk-delay": 0,
                  "hotkeys": {},
                  "deinterlace_mode": 0,
                  "deinterlace_field_order": 0,
                  "monitoring_type": 0,
                  "private_settings": {}
              },
              {
                  "prev_ver": 520093699,
                  "name": "Juegos - Audio",
                  "uuid": "33fbe49e-c23f-4f8c-af7e-407019801b28",
                  "id": "pipewire_audio_application_capture",
                  "versioned_id": "pipewire_audio_application_capture",
                  "settings": {},
                  "mixers": 197,
                  "sync": 0,
                  "flags": 0,
                  "volume": 1.0,
                  "balance": 0.5,
                  "enabled": true,
                  "muted": false,
                  "push-to-mute": false,
                  "push-to-mute-delay": 0,
                  "push-to-talk": false,
                  "push-to-talk-delay": 0,
                  "hotkeys": {
                      "libobs.mute": [],
                      "libobs.unmute": [],
                      "libobs.push-to-mute": [],
                      "libobs.push-to-talk": []
                  },
                  "deinterlace_mode": 0,
                  "deinterlace_field_order": 0,
                  "monitoring_type": 0,
                  "private_settings": {}
              }
          ],
          "groups": [],
          "quick_transitions": [
              {
                  "name": "Corte",
                  "duration": 300,
                  "hotkeys": [],
                  "id": 1,
                  "fade_to_black": false
              },
              {
                  "name": "Desvanecimiento",
                  "duration": 300,
                  "hotkeys": [],
                  "id": 2,
                  "fade_to_black": false
              },
              {
                  "name": "Desvanecimiento",
                  "duration": 300,
                  "hotkeys": [],
                  "id": 3,
                  "fade_to_black": true
              }
          ],
          "transitions": [],
          "saved_projectors": [],
          "current_transition": "Desvanecimiento",
          "transition_duration": 300,
          "preview_locked": false,
          "scaling_enabled": false,
          "scaling_level": 0,
          "scaling_off_x": 0.0,
          "scaling_off_y": 0.0,
          "modules": {
              "scripts-tool": [],
              "output-timer": {
                  "streamTimerHours": 0,
                  "streamTimerMinutes": 0,
                  "streamTimerSeconds": 30,
                  "recordTimerHours": 0,
                  "recordTimerMinutes": 0,
                  "recordTimerSeconds": 30,
                  "autoStartStreamTimer": false,
                  "autoStartRecordTimer": false,
                  "pauseRecordTimer": true
              }
          },
          "version": 2
      }
    '';
  };

  xdg.configFile."obs-studio/user.ini" = {
    text = ''
        		[General]
      Pre19Defaults=false
      Pre21Defaults=false
      Pre23Defaults=false
      Pre24.1Defaults=false
      ConfirmOnExit=true
      HotkeyFocusType=NeverDisableHotkeys
      FirstRun=true

      [BasicWindow]
      PreviewEnabled=true
      PreviewProgramMode=false
      SceneDuplicationMode=true
      SwapScenesMode=true
      SnappingEnabled=true
      ScreenSnapping=true
      SourceSnapping=true
      CenterSnapping=false
      SnapDistance=10
      SpacingHelpersEnabled=true
      RecordWhenStreaming=false
      KeepRecordingWhenStreamStops=false
      SysTrayEnabled=true
      SysTrayWhenStarted=false
      SaveProjectors=false
      ShowTransitions=true
      ShowListboxToolbars=true
      ShowStatusBar=true
      ShowSourceIcons=true
      ShowContextToolbars=true
      StudioModeLabels=true
      VerticalVolControl=false
      MultiviewMouseSwitch=true
      MultiviewDrawNames=true
      MultiviewDrawAreas=true
      MediaControlsCountdownTimer=true
      geometry=AdnQywADAAAAAAAAAAAAAAAAB1UAAAPoAAAAAAAAAAAAAAdVAAAD6AAAAAACAAAAB4AAAAAAAAAAAAAAB1UAAAPo
      DockState=AAAA/wAAAAD9AAAAAQAAAAMAAAdWAAAA2PwBAAAABvsAAAAUAHMAYwBlAG4AZQBzAEQAbwBjAGsBAAAAAAAAAW4AAACYAP////sAAAAWAHMAbwB1AHIAYwBlAHMARABvAGMAawEAAAFyAAABZgAAAJgA////+wAAABIAbQBpAHgAZQByAEQAbwBjAGsBAAAC3AAAAdQAAADeAP////sAAAAeAHQAcgBhAG4AcwBpAHQAaQBvAG4AcwBEAG8AYwBrAQAABLQAAAFOAAAApQD////7AAAAGABjAG8AbgB0AHIAbwBsAHMARABvAGMAawEAAAYGAAABUAAAAKIA////+wAAABIAcwB0AGEAdABzAEQAbwBjAGsCAAACYgAAAbgAAAK8AAAAyAAAB1YAAALUAAAABAAAAAQAAAAIAAAACPwAAAAA
      AlwaysOnTop=false
      EditPropertiesMode=false
      DocksLocked=false
      SideDocks=false

      [Basic]
      Profile=YouTube
      ProfileDir=YouTube
      SceneCollection=Sin Título
      SceneCollectionFile=Sin_Título
      ConfigOnNewProfile=true

      [Accessibility]
      SelectRed=255
      SelectGreen=65280
      SelectBlue=16744192
      MixerGreen=2522918
      MixerYellow=2523007
      MixerRed=2500223
      MixerGreenActive=5046092
      MixerYellowActive=5046271
      MixerRedActive=5000447

      [ScriptLogWindow]
      geometry=AdnQywADAAAAAAABAAAAGQAAAlgAAAGoAAAAAQAAABkAAAJYAAABqAAAAAAAAAAAB4AAAAABAAAAGQAAAlgAAAGo
    '';
  };
}
