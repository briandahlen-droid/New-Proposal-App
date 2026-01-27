# Setup Guide for New Proposal App

This guide walks you through setting up the clean repository from scratch.

## Prerequisites

- Python 3.10 or higher
- Git installed
- Access to Kimley-Horn internal files (eContractMaster.xlsm, Proposal Task Tool.xlsx, Template.docx)

---

## Step 1: Clone the Repository

```bash
git clone https://github.com/briandahlen-droid/New-Proposal-App.git
cd New-Proposal-App
```

---

## Step 2: Install Python Dependencies

```bash
# Create virtual environment (recommended)
python -m venv venv

# Activate virtual environment
# On Windows:
venv\Scripts\activate
# On Mac/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

---

## Step 3: Add Required Kimley-Horn Files

You need to add these files from your Kimley-Horn resources:

### ⚠️ REQUIRED FILES:

1. **eContractMaster.xlsm**
   - Location: `data/eContractMaster.xlsm`
   - Source: Kimley-Horn eContract system
   - Purpose: Task descriptions and standard scopes
   - Sheet required: "TaskDescriptions"

2. **Proposal Task Tool.xlsx**
   - Location: `data/Proposal Task Tool.xlsx`
   - Source: Kimley-Horn proposal database
   - Purpose: County/municipality-specific tasks
   - Sheets required: Task lists by category

3. **Template.docx**
   - Location: `assets/Template.docx`
   - Source: Kimley-Horn corporate template
   - Purpose: Tokenized proposal template
   - Must contain tokens like: `{{CLIENT_NAME}}`, `{{PROJECT_NAME}}`, etc.

### Optional Files:

4. **pinellas_county_cities_lookup.json** (Optional)
   - Location: `data/pinellas_county_cities_lookup.json`
   - Purpose: City name mapping/validation
   - Note: App has built-in fallback if this file is missing

---

## Step 4: Verify File Structure

After adding files, your structure should look like:

```
New-Proposal-App/
├── app.py                                      ✅ (included)
├── requirements.txt                            ✅ (included)
├── README.md                                   ✅ (included)
├── .gitignore                                  ✅ (included)
├── .streamlit/
│   └── config.toml                             ✅ (included)
├── data/
│   ├── eContractMaster.xlsm                    ⚠️  YOU ADD THIS
│   ├── Proposal Task Tool.xlsx                 ⚠️  YOU ADD THIS
│   └── pinellas_county_cities_lookup.json      (optional)
├── assets/
│   └── Template.docx                           ⚠️  YOU ADD THIS
├── output/
│   └── .gitkeep                                ✅ (included)
└── docs/
    └── [documentation files]                   ✅ (included)
```

---

## Step 5: Test Locally

```bash
streamlit run app.py
```

The app will open at `http://localhost:8501`

### Quick Test Checklist:

1. **Property Lookup Tab**
   - Enter a Pinellas parcel ID
   - Click "Lookup Property Data"
   - ✅ Should return: address, owner, city, acreage

2. **Zoning Lookup**
   - After property lookup, click "Lookup Zoning / Future Land Use"
   - ✅ Should return: zoning code and description

3. **Try Multiple Cities**
   - Test St. Petersburg address
   - Test Dunedin address (should now work!)
   - Test Tarpon Springs address (should now work!)

4. **Scope Tab**
   - ✅ Should load tasks from Excel files
   - ✅ Should display categories

5. **Generate**
   - Fill out minimum required fields
   - Click "Generate DOCX"
   - ✅ Should create downloadable proposal

---

## Step 6: Deploy to Streamlit Cloud

### A. Prepare for Deployment

1. **DO NOT commit sensitive files** (they're in .gitignore):
   - eContractMaster.xlsm
   - Proposal Task Tool.xlsx
   - Template.docx

2. **Commit code only**:
```bash
git add app.py requirements.txt README.md .gitignore .streamlit/
git commit -m "Initial commit - clean repo structure"
git push origin main
```

### B. Deploy on Streamlit Cloud

1. Go to https://share.streamlit.io
2. Click "New app"
3. Repository: `briandahlen-droid/New-Proposal-App`
4. Branch: `main`
5. Main file path: `app.py`
6. Click "Deploy"

### C. Upload Required Files to Deployed App

After deployment, Streamlit Cloud provides a file uploader:

1. In Streamlit Cloud dashboard, click on your app
2. Go to "Settings" → "Secrets and file uploads"
3. Upload these files:
   - `data/eContractMaster.xlsm`
   - `data/Proposal Task Tool.xlsx`
   - `assets/Template.docx`

**Alternative**: Use GitHub private repo and commit encrypted files.

---

## Step 7: Share with Team

Once deployed, share the Streamlit Cloud URL with Kimley-Horn colleagues:
```
https://[your-app-name].streamlit.app
```

---

## Troubleshooting

### "No such file or directory" errors

**Problem**: Missing data/assets files

**Solution**: Verify files exist:
```bash
ls -la data/
ls -la assets/
```

Expected files:
- `data/eContractMaster.xlsm` ✅
- `data/Proposal Task Tool.xlsx` ✅
- `assets/Template.docx` ✅

### "No tasks available" in Scope tab

**Problem**: Excel files not loading correctly

**Solution**: 
1. Verify Excel file names match exactly (case-sensitive)
2. Check file permissions (should be readable)
3. Open Excel files directly to verify "TaskDescriptions" sheet exists

### "Could not geocode address" errors

**Problem**: Address format not recognized

**Solution**:
- Include full address with city (e.g., "200 CENTRAL AVE, St. Petersburg")
- Verify parcel lookup completed first (provides accurate address)

### Zoning lookup returns "Contact City"

**Problem**: Consolidated service failed and no fallback available

**Solution**:
- Verify internet connectivity to egis.pinellas.gov
- Check Streamlit Cloud logs for specific error
- Try city-specific endpoint as temporary workaround

---

## Development Workflow

### Making Changes:

1. **Always create a new branch**:
```bash
git checkout -b feature/my-new-feature
```

2. **Test locally first**:
```bash
streamlit run app.py
```

3. **Commit and push**:
```bash
git add .
git commit -m "Description of changes"
git push origin feature/my-new-feature
```

4. **Deploy to Streamlit Cloud** (auto-deploys on push to main)

### Adding New Counties:

See `docs/Tampa_Bay_6_County_Integration_Guide.md` for:
- Hillsborough County endpoints
- Pasco County endpoints
- County adapter pattern
- Implementation examples

---

## File Upload Limits

- Streamlit Cloud: 200MB max per file
- Excel files (eContract, Task Tool): Should be well under limit
- Template.docx: Should be under 10MB

---

## Security Notes

**What's in Git:**
- ✅ Python code (app.py)
- ✅ Dependencies (requirements.txt)
- ✅ Configuration (config.toml)
- ✅ Documentation

**What's NOT in Git** (in .gitignore):
- ❌ eContractMaster.xlsm (proprietary)
- ❌ Proposal Task Tool.xlsx (proprietary)
- ❌ Template.docx (proprietary)
- ❌ Generated proposals (client data)

Keep it this way to protect Kimley-Horn intellectual property.

---

## Getting Help

**For App Issues:**
- Check `docs/CHANGES_SUMMARY.md` for recent changes
- Review Streamlit logs in Cloud dashboard
- Create GitHub issue with error details

**For Data/Template Issues:**
- Contact Kimley-Horn IT/Development Services team
- Verify you have latest versions of Excel files

**For GIS/API Issues:**
- Pinellas Planning Council: (727) 464-8250
- Pinellas Property Appraiser: (727) 464-3207

---

## Maintenance

### Regular Updates:

**Monthly:**
- Check for Streamlit updates: `pip install --upgrade streamlit`
- Verify API endpoints still active
- Update task databases if Kimley-Horn standards change

**Quarterly:**
- Review and update Template.docx if corporate standards change
- Test all municipalities for data accuracy
- Update Python dependencies

**Annually:**
- Verify zoning/FLU data current with county planning departments
- Review and update fee structures
- Audit generated proposals for quality

---

## Success Metrics

This app is working correctly when:
- ✅ All 24 Pinellas cities return zoning data
- ✅ Property lookups complete in < 5 seconds
- ✅ Generated proposals match corporate template exactly
- ✅ No manual data entry required (full auto-population)
- ✅ Zero "Contact City for zoning" responses in Pinellas

---

## Version History

- **v1.0** (January 2026) - Initial clean repo with Pinellas consolidated zoning
- Future versions will add additional counties
