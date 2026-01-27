# Assets Directory

This directory contains Kimley-Horn proposal templates.

## Required Files (Not in Git)

### Template.docx
**Source**: Kimley-Horn corporate standards  
**Purpose**: Tokenized Word template for proposals  
**Format**: Microsoft Word (.docx)

**Required Tokens** (must be in template):
- `{{PROPOSAL_DATE}}`
- `{{CLIENT_NAME}}`
- `{{CLIENT_CONTACT_NAME}}`
- `{{ENTITY_NAME}}`
- `{{PROJECT_NAME}}`
- `{{PROJECT_LOCATION}}`
- `{{CITY_STATE}}`
- `{{PARCEL_ID}}`
- `{{ZONING_FULL}}`
- `{{FLU_FULL}}`
- `{{SITE_AREA_ACRES}}`
- `{{FEE_TYPE}}`
- `{{FEE_TOTAL}}`
- `{{FEE_PARAGRAPH}}`
- `{{INSERT_SCOPE_TASKS}}` - Anchor for task sections
- `{{INSERT_PERMITS}}` - Anchor for permit list
- `{{INSERT_ADDITIONAL_SERVICES}}` - Anchor for additional services
- Fee table anchor for fee breakdown

## Security Note

⚠️ Template files are excluded from Git because they contain:
- Proprietary Kimley-Horn branding
- Corporate formatting standards
- Internal document structures

**Never commit template files to public repositories.**

## Customization

If you need to customize the template:
1. Make a copy: `Template_CUSTOM.docx`
2. Update token placeholders as needed
3. Test with app before deploying
