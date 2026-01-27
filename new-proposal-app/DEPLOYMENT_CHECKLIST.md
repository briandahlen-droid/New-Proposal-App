# Deployment Checklist

Use this checklist when setting up the New Proposal App repo.

## ☐ Initial Setup

- [ ] Clone repository from GitHub
- [ ] Create virtual environment (`python -m venv venv`)
- [ ] Activate virtual environment
- [ ] Install dependencies (`pip install -r requirements.txt`)

## ☐ Add Required Files

- [ ] Add `data/eContractMaster.xlsm`
- [ ] Add `data/Proposal Task Tool.xlsx`
- [ ] Add `assets/Template.docx`
- [ ] (Optional) Add `data/pinellas_county_cities_lookup.json`

## ☐ Local Testing

- [ ] Run app locally (`streamlit run app.py`)
- [ ] Test property lookup (St. Petersburg address)
- [ ] Test zoning lookup (St. Petersburg)
- [ ] Test new city (Dunedin or Tarpon Springs)
- [ ] Test scope task loading
- [ ] Generate test proposal document
- [ ] Verify document downloads correctly

## ☐ Git Repository

- [ ] Initialize Git (if not cloned): `git init`
- [ ] Add remote: `git remote add origin https://github.com/briandahlen-droid/New-Proposal-App.git`
- [ ] Verify .gitignore excludes sensitive files
- [ ] Commit code only: `git add app.py requirements.txt README.md`
- [ ] First commit: `git commit -m "Initial commit - Pinellas consolidated zoning"`
- [ ] Push to GitHub: `git push -u origin main`

## ☐ Streamlit Cloud Deployment

- [ ] Go to https://share.streamlit.io
- [ ] Click "New app"
- [ ] Select repository: `briandahlen-droid/New-Proposal-App`
- [ ] Branch: `main`
- [ ] Main file: `app.py`
- [ ] Click "Deploy"
- [ ] Wait for deployment (2-5 minutes)

## ☐ Upload Files to Streamlit Cloud

After deployment completes:

- [ ] Go to app settings in Streamlit Cloud
- [ ] Navigate to file upload section
- [ ] Upload `data/eContractMaster.xlsm`
- [ ] Upload `data/Proposal Task Tool.xlsx`
- [ ] Upload `assets/Template.docx`
- [ ] Restart app

## ☐ Production Testing

Test the deployed app:

- [ ] Open Streamlit Cloud app URL
- [ ] Test property lookup (known Pinellas parcel)
- [ ] Test zoning lookup (verify data appears)
- [ ] Test multiple cities (St. Pete, Clearwater, Dunedin)
- [ ] Generate test proposal
- [ ] Download and verify document format
- [ ] Share URL with one colleague for feedback

## ☐ Team Rollout

- [ ] Share app URL with Development Services team
- [ ] Provide quick start guide
- [ ] Collect initial feedback
- [ ] Document any issues
- [ ] Plan next county expansion (Hillsborough, Pasco, etc.)

## ☐ Maintenance Setup

- [ ] Bookmark Streamlit Cloud dashboard
- [ ] Save GIS contact info (Pinellas Planning Council, PCPAO)
- [ ] Schedule monthly update check
- [ ] Create feedback collection method

---

## Quick Commands Reference

```bash
# Local testing
streamlit run app.py

# Git workflow
git status
git add .
git commit -m "Description"
git push origin main

# Python verification
python3 -m py_compile app.py

# Dependency check
pip list
```

---

## Rollback Plan

If deployment has issues:

**Option 1**: Revert to previous version
```bash
git revert HEAD
git push origin main
```

**Option 2**: Use previous repo temporarily while debugging
- Original repo: [old repo URL]
- This gives you time to fix issues

**Option 3**: Deploy to test environment first
- Create separate Streamlit Cloud app for testing
- Validate fully before replacing production

---

## Success Criteria

✅ App is production-ready when:
- Property lookups work for all Pinellas cities
- Zoning data returns for Dunedin, Tarpon Springs, etc.
- No "Contact City" messages in Pinellas
- Documents generate with correct formatting
- Team can access and use without issues

---

## Emergency Contacts

**App Issues**: Brian Dahlen (Kimley-Horn)  
**GIS Data Issues**: Pinellas Planning Council (727) 464-8250  
**Property Data Issues**: Pinellas Property Appraiser (727) 464-3207  
**Streamlit Cloud Support**: https://discuss.streamlit.io
