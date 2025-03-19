#!/bin/bash

# Set variables for audio devices and recording directory
mic="alsa_input.usb-DCMT_Technology_USB_Condenser_Microphone_214b206000000178-00.pro-input-0"
headphones="bluez_output.38_18_4C_24_F1_94.1.monitor"
save_dir="$HOME/recordings"

# Create recordings directory if it doesn't exist
mkdir -p "$save_dir"

# Function to check if audio sources are available
is_source_available() {
  pactl list sources short | awk '{print $2}' | grep -q "$1"
}

# Read the file name
read -p "Input your file name: " output_name

# Create a temporary file to store selections
selection_file=$(mktemp)

# Define recording options
options=(
  "Monitor 1 (main)"
  "Monitor 2 (secondary)"
  "System Audio"
  "Microphone"
)

# Function to select recording options
select_options() {
  # First ask for monitor
  echo "Select monitor to record:"
  monitor=$(gum choose "Monitor 1 (main)" "Monitor 2 (secondary)" "None")
  echo "$monitor" >>"$selection_file"

  # Ask for audio options (can select multiple with separate prompts)
  echo "Include system audio? (Speaker output)"
  if gum confirm; then
    echo "System Audio" >>"$selection_file"
  fi

  echo "Include microphone input?"
  if gum confirm; then
    echo "Microphone" >>"$selection_file"
  fi
}

# Run the selection process
select_options

# Read selections into an array
selected_array=()
while IFS= read -r line; do
  if [[ "$line" != "None" ]]; then
    selected_array+=("$line")
  fi
done <"$selection_file"

# Clean up temporary file
rm "$selection_file"

# Check if at least one option was selected
if [ ${#selected_array[@]} -eq 0 ]; then
  echo "No options selected. Exiting."
  exit 1
fi

# Print selected options for troubleshooting
echo "Selected options:"
for option in "${selected_array[@]}"; do
  echo "  - $option"
done

# Initialize ffmpeg command parts
video_inputs=""
audio_inputs=""
filter_complex=""
video_mapping=""
audio_mapping=""
video_input_count=0
audio_input_count=0
has_monitor=0
has_mic=0
has_sys_audio=0

# Configure video input based on monitor selection
for option in "${selected_array[@]}"; do
  if [[ "$option" == "Monitor 1 (main)" && $has_monitor -eq 0 ]]; then
    video_inputs+="-f x11grab -video_size 2560x1440 -framerate 30 -i :0.0+1440,439 "
    monitor_index=$video_input_count
    has_monitor=1
    video_input_count=$((video_input_count + 1))
  elif [[ "$option" == "Monitor 2 (secondary)" && $has_monitor -eq 0 ]]; then
    video_inputs+="-f x11grab -video_size 1440x2560 -framerate 30 -i :0.0+0,0 "
    monitor_index=$video_input_count
    has_monitor=1
    video_input_count=$((video_input_count + 1))
  fi
done

# Configure audio inputs for microphone and system audio
for option in "${selected_array[@]}"; do
  if [[ "$option" == "Microphone" ]]; then
    if ! is_source_available "$mic"; then
      echo "Microphone not found. Exiting."
      exit 1
    fi
    audio_inputs+="-f pulse -i $mic "
    has_mic=1
    audio_input_count=$((audio_input_count + 1))
  elif [[ "$option" == "System Audio" ]]; then
    if ! is_source_available "$headphones"; then
      echo "System audio source not found. Exiting."
      exit 1
    fi
    audio_inputs+="-f pulse -i $headphones "
    has_sys_audio=1
    audio_input_count=$((audio_input_count + 1))
  fi
done

# Adjust indices for filter complex based on audio inputs
if [[ $audio_input_count -gt 0 ]]; then
  monitor_index=$((audio_input_count + monitor_index))
fi

# Build filter complex and mapping for audio
if [[ $has_mic -eq 1 && $has_sys_audio -eq 1 ]]; then
  # Both microphone and system audio
  filter_complex="-filter_complex \"[0:a]pan=stereo|c0=c0|c1=c0[mic]; [mic][1:a]amerge=inputs=2[a]\""
  audio_mapping="-map \"[a]\" "
elif [[ $has_mic -eq 1 ]]; then
  # Only microphone
  filter_complex="-filter_complex \"[0:a]pan=stereo|c0=c0|c1=c0[mic]\""
  audio_mapping="-map \"[mic]\" "
elif [[ $has_sys_audio -eq 1 ]]; then
  # Only system audio
  audio_mapping="-map 0:a "
fi

# Map video inputs as normal
if [[ $has_monitor -eq 1 ]]; then
  video_mapping="-map ${monitor_index}:v "
fi

# Build encoding parameters
encoding_params=""

# Different encoding settings for different scenarios
if [[ $video_input_count -gt 0 ]]; then
  # Monitor-only recording - prioritize quality and efficiency
  encoding_params+="-c:v libx264 -pix_fmt yuv420p -preset veryfast -crf 18 "
fi

if [[ $audio_input_count -gt 0 ]]; then
  # Audio encoding parameters - balanced quality
  encoding_params+="-c:a aac -b:a 160k -ar 44100 -ac 2 "
fi

# Build the final ffmpeg command
ffmpeg_cmd="ffmpeg $audio_inputs $video_inputs"

# Add filter complex if we have one
if [[ ! -z "$filter_complex" ]]; then
  ffmpeg_cmd+="$filter_complex "
fi

# Add mapping
if [[ ! -z "$audio_mapping" ]]; then
  ffmpeg_cmd+="$audio_mapping"
fi

if [[ ! -z "$video_mapping" ]]; then
  ffmpeg_cmd+="$video_mapping"
fi

# Add encoding parameters
ffmpeg_cmd+="$encoding_params"

# Add output file
ffmpeg_cmd+="-y \"$save_dir/$output_name.mp4\""

# Display command for debugging
echo "Executing command:"
echo "$ffmpeg_cmd"

# Execute the command
eval "$ffmpeg_cmd"

# Check if recording was successful
if [ $? -eq 0 ]; then
  echo "Recording completed successfully!"
  echo "Saved to: $save_dir/$output_name.mp4"
else
  echo "Recording failed with error code $?"
fi
