#!/bin/bash

POSTS_DIR=~/second-brain/3-resources/blog-posts
DEST_DIR=./src/content/blog
FILES=$(find $POSTS_DIR -type f -name "*.md" | sed "s,$POSTS_DIR,,g")

ASSETS_DIR=~/second-brain/3-resources/blog-posts/assets/imgs
ASSETS_DEST_DIR=./src/assets/images/
ASSETS_FILES=$(find $ASSETS_DIR -type f)

# Determine the appropriate stat command based on the operating system
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  stat_command="stat -c %Y"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  stat_command="stat -f %m"
else
  echo "Unsupported OS type: $OSTYPE"
  exit 1
fi

# Function to check if file exists and get modification time
get_mod_time() {
  local file="$1"
  if [ -f "$file" ]; then
    $stat_command "$file" 2>/dev/null
  else
    echo "0"
  fi
}

# Copy assets
for FILE in $ASSETS_FILES; do
  src_file="$FILE"
  dest_file="$ASSETS_DEST_DIR$(basename $FILE)"
  
  # Get the last modification times
  src_mod_time=$(get_mod_time "$src_file")
  dest_mod_time=$(get_mod_time "$dest_file")
  
  if [ ! -f "$dest_file" ] || [ "$src_mod_time" -ne "$dest_mod_time" ]; then
    cp "$src_file" "$dest_file"
  fi
done

# Function to update links in a file
update_links() {
  local file="$1"
  local src_pattern="3-resources/blog-posts/assets/imgs/"
  local dest_pattern="@assets/images/"

  sed "s,$src_pattern,$dest_pattern,g" "$file"
}

for FILE in $FILES; do
  src_file="$POSTS_DIR$FILE"
  dest_file="$DEST_DIR$FILE"
  
  # Get the last modification times
  src_mod_time=$(get_mod_time "$src_file")
  dest_mod_time=$(get_mod_time "$dest_file")
  
  if [ ! -f "$dest_file" ] || [ "$src_mod_time" -ne "$dest_mod_time" ]; then
    cp "$src_file" tmp
    # Find the end of frontmatter (second set of ---)
    end_of_frontmatter=$(awk '/^---$/ { ++c } c==2 { print NR; exit }' tmp)

    # Check if two lines below the end of frontmatter starts with "# "
    title_line=$(awk "NR==$(($end_of_frontmatter + 2)) { if (\$0 ~ /^# /) print \$0 }" tmp)

    if [ -n "$title_line" ]; then
        # Extract title from the line
        title=$(echo "$title_line" | sed 's/^# //')

        # Replace title: field in frontmatter
        sed -i '' -e "s/^title: .*/title: \"$title\"/" tmp

        # Delete the line containing the title
        sed -i '' -e "$(($end_of_frontmatter + 2))d" tmp
    fi

    # Update the modDatetime field in the file
    sed "s/^modDatetime: .*/modDatetime: $(date -u "+%Y-%m-%dT%H:%M:%S.000Z")/" tmp
    
    # Update links in the file
    update_links tmp

    # Move updated file to destination directory
    mv tmp "$dest_file"
  fi
done

# # Commit changes to git
# git add .
# git commit -m "Sync posts"
# git push

echo "Done syncing posts."
