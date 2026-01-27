# Data Directory

This directory contains Kimley-Horn specific data files needed for the application.

## Required Files (Not in Git)

Add these files from your Kimley-Horn resources:

### 1. eContractMaster.xlsm
**Source**: Kimley-Horn eContract system  
**Purpose**: Standard task descriptions  
**Required Sheet**: "TaskDescriptions"  
**Format**: Excel with macros (.xlsm)

### 2. Proposal Task Tool.xlsx
**Source**: Kimley-Horn proposal database  
**Purpose**: Municipality-specific tasks and descriptions  
**Required Sheets**: Task categories  
**Format**: Excel workbook (.xlsx)

### 3. pinellas_county_cities_lookup.json (Optional)
**Source**: Generated from Pinellas city list  
**Purpose**: City name mapping and validation  
**Format**: JSON  
**Note**: App has built-in fallback if missing

## Security Note

⚠️ These files are excluded from Git (.gitignore) because they contain:
- Proprietary Kimley-Horn information
- Internal task structures
- Corporate standards

**Never commit these files to public repositories.**

## Verification

After adding files, verify they load:

```bash
python3 -c "from openpyxl import load_workbook; wb = load_workbook('data/eContractMaster.xlsm', data_only=True); print('✅ eContract loaded')"
python3 -c "from openpyxl import load_workbook; wb = load_workbook('data/Proposal Task Tool.xlsx', data_only=True); print('✅ Task Tool loaded')"
```
