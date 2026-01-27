# Kimley-Horn Development Services Proposal Generator

A Streamlit application for automating Development Services proposals for Tampa Bay area projects. Features comprehensive property lookup for Pinellas County (all 24 municipalities) with support for zoning, future land use, and proposal document generation.

## Features

- ✅ **Property Lookup**: All Pinellas County municipalities (St. Petersburg, Clearwater, Largo, Dunedin, Tarpon Springs, etc.)
- ✅ **Zoning & Future Land Use**: Automated lookup using Pinellas Planning Council consolidated service
- ✅ **Task Management**: Import and manage proposal tasks from eContract and Proposal Task Tool
- ✅ **Document Generation**: Create professional proposals from tokenized Word templates
- ✅ **Multi-Tab Workflow**: Intake, Client, Project, Scope, Permits, Fees, Review & Generate

## Repository Structure

```
new-proposal-app/
├── app.py                          # Main Streamlit application
├── requirements.txt                # Python dependencies
├── README.md                       # This file
├── SETUP.md                        # Detailed setup instructions
├── .gitignore                      # Git ignore patterns
├── .streamlit/
│   └── config.toml                 # Streamlit configuration
├── data/
│   ├── eContractMaster.xlsm        # ⚠️ ADD THIS: Kimley-Horn task descriptions
│   ├── Proposal Task Tool.xlsx     # ⚠️ ADD THIS: Proposal task database
│   └── pinellas_county_cities_lookup.json  # Optional: City name mappings
├── assets/
│   └── Template.docx               # ⚠️ ADD THIS: Proposal Word template
├── output/
│   └── .gitkeep                    # Generated proposals save here
└── docs/
    ├── CHANGES_SUMMARY.md          # Latest changes documentation
    └── Tampa_Bay_6_County_Integration_Guide.md  # Future county expansion guide
```

## Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/briandahlen-droid/New-Proposal-App.git
cd New-Proposal-App
```

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Add Required Files
You need to add these Kimley-Horn specific files (not in repo):

**Required:**
- `data/eContractMaster.xlsm` - Task descriptions from eContract
- `data/Proposal Task Tool.xlsx` - Proposal task database
- `assets/Template.docx` - Tokenized proposal template

**Optional:**
- `data/pinellas_county_cities_lookup.json` - City name lookup (app has fallback)

### 4. Run Application
```bash
streamlit run app.py
```

App will open at `http://localhost:8501`

## Deployment to Streamlit Cloud

### 1. Push to GitHub
```bash
git add .
git commit -m "Initial commit"
git push origin main
```

### 2. Deploy on Streamlit Cloud
1. Go to https://share.streamlit.io
2. Click "New app"
3. Select this repository
4. Main file: `app.py`
5. Click "Deploy"

### 3. Add Required Files to Deployed App
After deployment, upload these files via the Streamlit Cloud interface:
- `data/eContractMaster.xlsm`
- `data/Proposal Task Tool.xlsx`
- `assets/Template.docx`

## Recent Updates

### January 2026 - Pinellas Consolidated Zoning Integration
- Added Pinellas Planning Council consolidated zoning service
- **Now supports ALL 24 Pinellas municipalities** (previously only 4)
- Enhanced St. Petersburg and Largo with detailed FLU data
- Improved fallback logic for reliability

See `docs/CHANGES_SUMMARY.md` for details.

## Property Lookup Coverage

### ✅ Fully Supported Counties:
- **Pinellas County** - All 24 municipalities

### 🔜 Coming Soon:
- Hillsborough County
- Pasco County
- Manatee County
- Sarasota County
- Polk County

## Architecture

### Lookup Flow:
```
User enters Parcel ID
    ↓
Query Pinellas Property Appraiser (owner, address, acreage)
    ↓
Query Pinellas Planning Council (zoning for all cities)
    ↓
Enhance with city-specific FLU (St. Pete, Largo, Unincorporated)
    ↓
Auto-populate proposal form
```

### Key Components:
- **Property Scraper**: `scrape_pinellas_property()` - PCPAO web scraping
- **Consolidated Zoning**: `lookup_pinellas_consolidated_zoning()` - All cities
- **Router**: `lookup_pinellas_zoning()` - Orchestrates lookups with enhancements
- **Document Generator**: `generate_proposal_docx()` - Token replacement in template

## Technical Notes

### API Endpoints Used:
- **Pinellas Property Appraiser**: `www.pcpao.gov/property-search-results`
- **Pinellas Planning Council**: `egis.pinellas.gov/gis/rest/services/AGO/PPC_Data/MapServer`
- **St. Petersburg GIS**: `egis.stpete.org/arcgis/rest/services/ServicesDSD/Zoning/MapServer`
- **Geocoding**: `geocode.arcgis.com` (for address → coordinates)

### Performance:
- Resilient session with retry logic (3 attempts, exponential backoff)
- Caching for task database (reduces Excel parsing on every interaction)
- Timeout handling (5s connect, 30s read)

## Support

**Issues/Questions:**
- Create GitHub issue in this repository
- Contact: Brian Dahlen, Kimley-Horn Development Services

**External Service Issues:**
- Pinellas Planning Council GIS: (727) 464-8250
- Pinellas Property Appraiser: (727) 464-3207

## License

Internal Kimley-Horn use only. Not for public distribution.
