import pandas as pd

# =====================================================
# NCRB MASTER CRIME WAREHOUSE
# =====================================================

BASE_PATH = "/Users/sumitbhandari/Desktop/NCRB"

# =====================================================
# LOAD DOMAIN DATASETS ONLY
# =====================================================

datasets = {

    "women": pd.read_csv(
        f"{BASE_PATH}/cleaned data/master_women_safety.csv"
    ),

    "children": pd.read_csv(
        f"{BASE_PATH}/cleaned data/mastered_children.csv"
    ),

    "sc": pd.read_csv(
        f"{BASE_PATH}/cleaned data/mastered_sc.csv"
    ),

    "st": pd.read_csv(
        f"{BASE_PATH}/cleaned data/mastered_st.csv"
    ),

    "senior": pd.read_csv(
        f"{BASE_PATH}/cleaned data/Mastered_senior.csv"
    ),

    "cybercrime": pd.read_csv(
        f"{BASE_PATH}/cleaned data/master_cybercrime.csv"
    ),

    "economic": pd.read_csv(
        f"{BASE_PATH}/cleaned data/master_economic_offences.csv"
    )
}

# =====================================================
# CREATE MASTER WAREHOUSE
# =====================================================

master_frames = []

for name, df in datasets.items():

    print(f"\nProcessing: {name}")

    # CLEAN COLUMN NAMES
    df.columns = (
        df.columns
        .str.lower()
        .str.strip()
        .str.replace(" ", "_")
    )

    # REQUIRED COLUMNS
    required_cols = [
        "year",
        "state",
        "city",
        "category",
        "cases",
        "crime_rate_2024",
        "chargesheeting_rate_2024"
    ]

    # ADD MISSING COLUMNS
    for col in required_cols:

        if col not in df.columns:
            df[col] = None

    # CLEAN TEXT COLUMNS ONLY
    for col in df.columns:

        if df[col].dtype == object:

            df[col] = (
                df[col]
                .astype(str)
                .str.replace(r'[\u2013\u2014]', '-', regex=True)
                .str.replace(r'[\u2018\u2019\u201c\u201d]', '', regex=True)
                .str.replace(r'[^\x00-\x7F]+', '', regex=True)
                .str.strip()
            )

    # ADD METADATA
    df["crime_domain"] = name

    victim_map = {
        "women": "Women",
        "children": "Children",
        "sc": "SC",
        "st": "ST",
        "senior": "Senior Citizens",
        "cybercrime": "Cybercrime",
        "economic": "Economic Offences"
    }

    df["victim_group"] = victim_map.get(
        name,
        "General"
    )

    df["source_table"] = name

    # FINAL COLUMNS
    final_cols = [
        "year",
        "state",
        "city",
        "category",
        "cases",
        "crime_rate_2024",
        "chargesheeting_rate_2024",
        "crime_domain",
        "victim_group",
        "source_table"
    ]

    df = df[final_cols]

    # APPEND
    master_frames.append(df)

# =====================================================
# COMBINE DATAFRAMES
# =====================================================

master_crime_warehouse = pd.concat(
    master_frames,
    ignore_index=True
)

# REMOVE DUPLICATES
master_crime_warehouse = (
    master_crime_warehouse
    .drop_duplicates()
)

# FILL NULLS
master_crime_warehouse = (
    master_crime_warehouse
    .fillna(0)
)

# =====================================================
# SAVE CSV
# =====================================================

output_path = (
    f"{BASE_PATH}/cleaned data/master_crime_warehouse.csv"
)

master_crime_warehouse.to_csv(
    output_path,
    index=False,
    encoding="ascii"
)

# =====================================================
# FINAL OUTPUT
# =====================================================

print("\n====================================")
print("MASTER WAREHOUSE CREATED")
print("====================================")

print("\nFinal Shape:")
print(master_crime_warehouse.shape)

print("\nSaved At:")
print(output_path)