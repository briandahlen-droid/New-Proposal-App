# Tampa Bay 6-County Zoning/FLU Integration Guide

## Overview

This guide provides **production-ready REST API endpoints** for retrieving zoning and future land use data for your top 6 Tampa Bay counties. Use this as your **primary data source** with the Florida statewide service as fallback.

---

## County API Endpoints Summary

| County | Zoning Endpoint | FLU Endpoint | Status |
|--------|----------------|--------------|---------|
| **Pinellas** | Multiple city endpoints | Multiple city endpoints | ✅ Already implemented |
| **Hillsborough** | ✅ Found | Need to verify | 🔍 Research needed |
| **Pasco** | ✅ Found | ✅ Found | 🔍 Research needed |
| **Manatee** | ✅ Found | Need to verify | 🔍 Research needed |
| **Sarasota** | ✅ Found | Need to verify | 🔍 Research needed |
| **Polk** | ✅ Found | ✅ Found | 🔍 Research needed |

---

## 1. PINELLAS COUNTY

**Status**: ✅ Already implemented in your current app

### Endpoints You Already Have:
- **St. Petersburg**: `https://maps.egis.stpete.org/arcgis/rest/services/Hosted/Properties_Basic/FeatureServer/0`
- **Clearwater**: `https://maps.egis.stpete.org/arcgis/rest/services/Hosted/Properties_Basic/FeatureServer/0`
- **Largo**: Specialized endpoint for FLU
- **Unincorporated**: `https://egis.pinellas.gov/arcgis/rest/services/apps/Zoning_FLU_PUBLIC/MapServer/`

**Key Fields**:
- Zoning: `ZONING`, `ZONING_DESC`
- FLU: `FLU`, `FLU_LONG`

---

## 2. HILLSBOROUGH COUNTY

### Zoning Endpoint
```
https://maps.hillsboroughcounty.org/arcgis/rest/services/DSD_Viewer_Services/DSD_Viewer_Zoning_Regulatory/FeatureServer/1
```

**Key Fields**:
- `NZONE` - Zoning code (e.g., "CG", "RSC-6")
- `NZONE_DESC` - Full zoning description (e.g., "Commercial, General")
- `OVERLAY` - Overlay district (if applicable)

**Query Pattern**:
```python
params = {
    'where': f"PARCELID='{parcel_id}'",  # Or use spatial query
    'outFields': 'NZONE,NZONE_DESC,OVERLAY',
    'returnGeometry': 'false',
    'f': 'json'
}
```

### Future Land Use Endpoint
```
Status: Need to verify endpoint - likely in same service family
Suggested: https://maps.hillsboroughcounty.org/arcgis/rest/services/.../FutureLandUse/...
```

**Alternative**: Use SWFWMD comprehensive planning endpoint

---

## 3. PASCO COUNTY

### Zoning Endpoint
```
https://mapping.pascopa.com/arcgis/rest/services/Land_Use/MapServer/1
```

**Layer Name**: "BOCC Zoning"

**Key Fields** (need verification):
- Zoning code field
- Zoning description field

### Future Land Use Endpoint
```
https://mapping.pascopa.com/arcgis/rest/services/Land_Use/MapServer/0
```

**Layer Name**: "BOCC Future Land Use"

**Query Pattern**:
```python
# Same as other counties - spatial query by parcel geometry or parcel ID match
params = {
    'where': f"PARCEL_ID='{parcel_id}'",
    'outFields': '*',
    'returnGeometry': 'false',
    'f': 'json'
}
```

---

## 4. MANATEE COUNTY

### Zoning Endpoint
```
https://www.mymanatee.org/gisits/rest/services/opendata/Planning/FeatureServer/0
```

**Layer Name**: "Zoning Districts"

**Key Fields**:
- `ZONELABEL` - Zoning code
- Additional description fields (verify with metadata)

### Planning/Land Use Endpoint
```
https://www.mymanatee.org/arcgis01/rest/services/landdevelopment/planning/MapServer/
```

**Layers**:
- Layer 0: Development of Regional Impact (DRI)
- Layer 1: Zoning

**Query Pattern**:
```python
# Spatial query approach (most reliable for Manatee)
params = {
    'geometry': f"{lon},{lat}",
    'geometryType': 'esriGeometryPoint',
    'spatialRel': 'esriSpatialRelIntersects',
    'inSR': 4326,
    'outFields': 'ZONELABEL',
    'returnGeometry': 'false',
    'f': 'json'
}
```

---

## 5. SARASOTA COUNTY

### Zoning Endpoint
```
https://data-sarco.opendata.arcgis.com/...
```

**Service Name**: "CountyZoning"

**Access via**: Sarasota County Enterprise GIS Open Data Portal

**Key Fields** (need verification):
- Zoning designation field
- Description field

**Alternative Endpoint** (SWFWMD):
```
https://www25.swfwmd.state.fl.us/arcgis12/rest/services/BaseVector/parcel_search/MapServer/15
```

---

## 6. POLK COUNTY

### Zoning Endpoint
```
https://gis.polk-county.net/hosting/rest/services/PublicViewer/Map_Land_Use_and_Zoning/MapServer/
```

**Layers**:
- Layer 8: Development Areas
- Layer 9: Future Land Use 2030
- Additional layers for zoning (verify layer index)

### Future Land Use Endpoint
```
https://gis.polk-county.net/hosting/rest/services/PublicViewer/Map_Land_Use_and_Zoning/MapServer/9
```

**Layer Name**: "Future Land Use 2030"

**Query Pattern**:
```python
# Same spatial query pattern
params = {
    'geometry': f"{lon},{lat}",
    'geometryType': 'esriGeometryPoint',
    'spatialRel': 'esriSpatialRelIntersects',
    'inSR': 4326,
    'outFields': '*',
    'returnGeometry': 'false',
    'f': 'json'
}
```

---

## Implementation Pattern: County Adapter

```python
from abc import ABC, abstractmethod
from typing import Optional, Dict
import requests

class CountyZoningAdapter(ABC):
    """Base adapter for county zoning/FLU lookups."""
    
    ZONING_ENDPOINT: str
    FLU_ENDPOINT: str
    ZONING_FIELD: str
    ZONING_DESC_FIELD: str
    FLU_FIELD: str
    FLU_DESC_FIELD: str
    
    @abstractmethod
    def lookup_by_parcel(self, parcel_id: str) -> Optional[Dict]:
        """Look up zoning/FLU by parcel ID."""
        pass
    
    @abstractmethod
    def lookup_by_coordinates(self, lon: float, lat: float) -> Optional[Dict]:
        """Look up zoning/FLU by coordinates (fallback method)."""
        pass


class HillsboroughAdapter(CountyZoningAdapter):
    """Hillsborough County zoning/FLU adapter."""
    
    ZONING_ENDPOINT = "https://maps.hillsboroughcounty.org/arcgis/rest/services/DSD_Viewer_Services/DSD_Viewer_Zoning_Regulatory/FeatureServer/1"
    ZONING_FIELD = "NZONE"
    ZONING_DESC_FIELD = "NZONE_DESC"
    
    def lookup_by_parcel(self, parcel_id: str) -> Optional[Dict]:
        """Query by parcel ID."""
        params = {
            'where': f"PARCELID='{parcel_id}'",
            'outFields': f'{self.ZONING_FIELD},{self.ZONING_DESC_FIELD}',
            'returnGeometry': 'false',
            'f': 'json'
        }
        
        try:
            response = requests.get(
                f"{self.ZONING_ENDPOINT}/query",
                params=params,
                timeout=(5, 30)
            )
            response.raise_for_status()
            data = response.json()
            
            features = data.get('features', [])
            if not features:
                return None
            
            attrs = features[0]['attributes']
            return {
                'zoning': attrs.get(self.ZONING_FIELD, ''),
                'zoning_description': attrs.get(self.ZONING_DESC_FIELD, ''),
                'county': 'Hillsborough'
            }
        except Exception as e:
            print(f"Hillsborough lookup failed: {e}")
            return None
    
    def lookup_by_coordinates(self, lon: float, lat: float) -> Optional[Dict]:
        """Query by coordinates (spatial query)."""
        params = {
            'geometry': f"{lon},{lat}",
            'geometryType': 'esriGeometryPoint',
            'spatialRel': 'esriSpatialRelIntersects',
            'inSR': 4326,
            'outFields': f'{self.ZONING_FIELD},{self.ZONING_DESC_FIELD}',
            'returnGeometry': 'false',
            'f': 'json'
        }
        
        try:
            response = requests.get(
                f"{self.ZONING_ENDPOINT}/query",
                params=params,
                timeout=(5, 30)
            )
            response.raise_for_status()
            data = response.json()
            
            features = data.get('features', [])
            if not features:
                return None
            
            attrs = features[0]['attributes']
            return {
                'zoning': attrs.get(self.ZONING_FIELD, ''),
                'zoning_description': attrs.get(self.ZONING_DESC_FIELD, ''),
                'county': 'Hillsborough'
            }
        except Exception as e:
            print(f"Hillsborough coordinate lookup failed: {e}")
            return None


class PascoAdapter(CountyZoningAdapter):
    """Pasco County zoning/FLU adapter."""
    
    ZONING_ENDPOINT = "https://mapping.pascopa.com/arcgis/rest/services/Land_Use/MapServer/1"
    FLU_ENDPOINT = "https://mapping.pascopa.com/arcgis/rest/services/Land_Use/MapServer/0"
    
    def lookup_by_parcel(self, parcel_id: str) -> Optional[Dict]:
        """Pasco likely requires spatial query - implement coordinate-based lookup."""
        # NOTE: May need to get coordinates from parcel first
        return None
    
    def lookup_by_coordinates(self, lon: float, lat: float) -> Optional[Dict]:
        """Query by coordinates."""
        # Get zoning
        zoning_params = {
            'geometry': f"{lon},{lat}",
            'geometryType': 'esriGeometryPoint',
            'spatialRel': 'esriSpatialRelIntersects',
            'inSR': 4326,
            'outFields': '*',
            'returnGeometry': 'false',
            'f': 'json'
        }
        
        zoning_data = self._query_endpoint(self.ZONING_ENDPOINT, zoning_params)
        flu_data = self._query_endpoint(self.FLU_ENDPOINT, zoning_params)
        
        if not zoning_data and not flu_data:
            return None
        
        return {
            'zoning': zoning_data.get('zoning_field', '') if zoning_data else '',
            'flu': flu_data.get('flu_field', '') if flu_data else '',
            'county': 'Pasco'
        }
    
    def _query_endpoint(self, endpoint: str, params: dict) -> Optional[Dict]:
        """Helper to query an endpoint."""
        try:
            response = requests.get(f"{endpoint}/query", params=params, timeout=(5, 30))
            response.raise_for_status()
            data = response.json()
            features = data.get('features', [])
            return features[0]['attributes'] if features else None
        except Exception:
            return None
```

---

## Integration Strategy: Two-Tier Lookup

```python
def lookup_property_data(parcel_id: str, county: str, coordinates: tuple = None):
    """
    Two-tier property lookup:
    1. Try county-specific zoning/FLU
    2. Fall back to statewide parcel data
    """
    
    # Tier 1: County-specific zoning/FLU
    adapter = get_county_adapter(county)
    if adapter:
        # Try parcel ID lookup first
        result = adapter.lookup_by_parcel(parcel_id)
        
        # Fall back to coordinate lookup if parcel ID fails
        if not result and coordinates:
            lon, lat = coordinates
            result = adapter.lookup_by_coordinates(lon, lat)
        
        if result:
            return result
    
    # Tier 2: Statewide fallback (basic data only)
    return lookup_statewide_data(parcel_id)
```

---

## Next Steps for Full Implementation

### Phase 1: Verify Field Mappings (1-2 days)
For each county endpoint:
1. Call `{endpoint}?f=pjson` to get layer metadata
2. Identify exact field names for zoning code, zoning description, FLU code, FLU description
3. Test sample queries with known parcel IDs

### Phase 2: Build County Adapters (2-3 days)
1. Implement each `CountyZoningAdapter` subclass
2. Add field mappings to class constants
3. Implement both parcel ID and coordinate lookup methods
4. Add error handling and timeout logic

### Phase 3: Integration Testing (1-2 days)
1. Test each county adapter with real parcel IDs
2. Verify zoning/FLU data matches county websites
3. Test fallback logic (coordinate lookup when parcel fails)
4. Load testing for production deployment

### Phase 4: UI Integration (1 day)
1. Update your Streamlit app to use county adapters
2. Display zoning and FLU in property lookup results
3. Add county selector dropdown
4. Show data source attribution (county vs statewide)

---

## Production Checklist

Before deploying to production:

- [ ] Verified all 6 county endpoints are accessible
- [ ] Documented exact field names for each county
- [ ] Tested with real parcel IDs from each county
- [ ] Implemented proper error handling
- [ ] Added request timeouts (5 second connect, 30 second read)
- [ ] Cached results to reduce API calls
- [ ] Added fallback to statewide data when county fails
- [ ] Tested coordinate-based spatial queries
- [ ] Validated data accuracy against county websites
- [ ] Added logging for debugging

---

## Maintenance Notes

**Update Frequency**:
- County zoning data: Updates vary by county (quarterly to annually)
- Check county GIS pages for data freshness

**API Stability**:
- County REST endpoints are generally stable
- Monitor for service outages or endpoint changes
- Keep backup contact info for county GIS departments

**Contact Info** (for API issues):
- **Hillsborough GIS**: maps.hillsboroughcounty.org
- **Pasco GIS**: (727) 847-8165
- **Manatee GIS**: https://www.mymanatee.org/gisits
- **Sarasota GIS**: https://data-sarco.opendata.arcgis.com
- **Polk GIS**: (863) 534-7575
