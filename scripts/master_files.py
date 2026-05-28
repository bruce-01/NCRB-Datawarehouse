import pandas as pd
import os

# =====================================================
# NCRB MYSQL CSV CLEANER
# =====================================================

# INPUT FOLDER
# INPUT FOLDER
INPUT_FOLDER = "/Users/sumitbhandari/Desktop/NCRB/cleaned data"

# OUTPUT FOLDER
OUTPUT_FOLDER = "/Users/sumitbhandari/Desktop/NCRB/cleaned data/mysql_ready"

# CREATE OUTPUT FOLDER
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# CREATE OUTPUT FOLDER IF NOT EXISTS
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# =====================================================
# FILES TO CLEAN
# =====================================================

FILES = [
    "fact_sll_crime_heads.csv",
    "fact_national_crime_summary.csv"
]

# =====================================================
# CLEAN FUNCTION
# =====================================================

def clean_text(value):

    if pd.isna(value):
        return value

    value = str(value)

    # Replace problematic unicode characters
    value = (
        value
        .replace("–", "-")
        .replace("—", "-")
        .replace("‘", "")
        .replace("’", "")
        .replace("“", "")
        .replace("”", "")
    )

    # Keep only ASCII characters
    value = value.encode(
        "ascii",
        "ignore"
    ).decode()

    return value.strip()

# =====================================================
# PROCESS FILES
# =====================================================

for file in FILES:

    print(f"\nProcessing: {file}")

    input_path = os.path.join(
        INPUT_FOLDER,
        file
    )

    try:

        # READ CSV
        df = pd.read_csv(input_path)

        # CLEAN COLUMN NAMES
        df.columns = [
            clean_text(col)
            for col in df.columns
        ]

        # CLEAN TEXT DATA
        for col in df.columns:

            if df[col].dtype == object:

                df[col] = df[col].apply(clean_text)

        # CREATE OUTPUT FILE NAME
        output_file = file.replace(
            ".csv",
            "_clean.csv"
        )

        output_path = os.path.join(
            OUTPUT_FOLDER,
            output_file
        )

        # SAVE CLEAN CSV
        df.to_csv(
            output_path,
            index=False,
            encoding="utf-8-sig"
        )

        print(f"Saved: {output_file}")

    except Exception as e:

        print(f"Error processing {file}")
        print(e)

print("\nAll files cleaned successfully.")