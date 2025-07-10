#!/bin/bash

# ==============================================================================
# BigQuery Table Copy Script
#
# Description:
#   This script copies multiple BigQuery tables with a date-based naming
#   convention (e.g., stops_YYYYMMDD) from a source project/dataset to a
#   destination project/dataset.
#
# Instructions:
#   1.  Fill in the configuration variables below with your project IDs,
#       datasets, and the list of dates for the tables you want to copy.
#   2.  Save the file.
#   3.  Make the script executable by running:
#       chmod +x bq_copy_tables.sh
#   4.  Execute the script from your terminal:
#       ./bq_copy_tables.sh
# ==============================================================================

# --- Configuration ---
# Set your source and destination project IDs and dataset names here.
SOURCE_PROJECT="glossy-apex-462002-i3"
SOURCE_DATASET="at_bus_bronze"
DEST_PROJECT="at-bus-465401"
DEST_DATASET="at_bus_bronze"

# --- List of Dates ---
# Add the dates for the tables you want to copy.
# The format should match your table names (e.g., "YYYYMMDD").
DATES=(
  "2025-06-17"
  "2025-06-18"
  "2025-06-19"
  "2025-06-20"
  "2025-06-21"
  "2025-06-22"
  "2025-06-23"
  "2025-06-24"
  "2025-06-25"
  "2025-06-26"
  "2025-06-27"
  "2025-06-28"
  "2025-06-29"
  "2025-06-30"
  "2025-07-01"
  "2025-07-02"
  "2025-07-03"
  "2025-07-04"
  "2025-07-05"
  "2025-07-06"
  "2025-07-07"
  "2025-07-08"
  "2025-07-09"
  "2025-07-10"
  "2025-07-11"
)

# --- Main Loop ---
# This loop iterates through each date, constructs the table names,
# and runs the bq cp command.
for DATE in "${DATES[@]}"; do
  TABLE_NAME="trips_8545-aed7c410_${DATE}"

  echo "---------------------------------"
  echo "Attempting to copy table: ${TABLE_NAME}"

  # Construct the full source and destination table paths
  SOURCE_TABLE_PATH="${SOURCE_PROJECT}:${SOURCE_DATASET}.${TABLE_NAME}"
  DEST_TABLE_PATH="${DEST_PROJECT}:${DEST_DATASET}.${TABLE_NAME}"

  echo "FROM: ${SOURCE_TABLE_PATH}"
  echo "TO:   ${DEST_TABLE_PATH}"

  # Execute the bq copy command
  bq cp --project_id "${DEST_PROJECT}" "${SOURCE_TABLE_PATH}" "${DEST_TABLE_PATH}"

  # Check the exit code of the last command
  if [ $? -eq 0 ]; then
    echo "SUCCESS: Copied ${TABLE_NAME} successfully."
  else
    echo "ERROR: Failed to copy ${TABLE_NAME}. Please check permissions and if the table exists." >&2
  fi
done

echo "---------------------------------"
echo "Script finished."
