if [ $__fish_config_dir = "/opt/idea/plugins/terminal/fish" ]
    set __fish_config_dir $HOME/.config/fish
end

if status is-interactive
    # motd
    set fish_greeting # disable default one
    fish $__fish_config_dir/motd.fish
    # man color
end

# tide config
set -g tide_character_color ef824c
set -g tide_character_color_failure EF4C80
set -g tide_pwd_color_dirs 495665
set -g tide_pwd_color_truncated_dirs 6F7A8C
set -g tide_pwd_color_anchors DD4676
set -g tide_prompt_color_frame_and_connection 6f7890
set -g tide_time_color ef824c
set -g tide_cmd_duration_color fbe36a