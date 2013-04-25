Data was last updated from FEC on $update_date

This gives a rough overview of the various MYSQL tables included in the API data dump. 

Tables used by API (record counts are as of 2010-12-13):

    * companies : meta information about 605,990 company entities (defines cw_id)
    * company_locations : 944,499 address or location tags for companies
    * company_names : 1,016,053 company name variants
    * company_relations : 1,222,105 parent-child relationships between companies
    * filings : info about 8,004,832 filing records since 2003-01-01 (only 37,274 are 10-K)

    industry classification

    * sic_codes : definitions of ~500 SIC industry codes
    * sic_sectors : definitions of middle level SIC industry sectors

    location tagging

    * un_countries ; official list of UN country names and codes
    * un_country_subdivisions : list of UN states, provinces, etc
  

More detailed descriptions of the fields in each table. Not all fields are described, some refer to the intermediate processing tables that are not included in the data dump.


companies:

    * cw_id : id for the company within our database
    * cik : SEC's Central Index Key id code for filing companies (null for most subsidiaries)
    * company_name : our standardized name for the company
    * irs_number : IRS EIN (tax id) for the company, if known
    * sic_category : Standard Industrial Classification code for the company, if known
    * industry_name : text version of the SIC code
    * sic_sector : code for the higher-level SIC sector
    * sector_name : text version of the higher-level SIC sector
    * best_location_id : id of the company_locations record that "best" describes this company
    * country_code : two-letter UN country code for raw_address
    * subdiv_code : two- or three-letter UN subdivision (state or province) code for raw_address
    * source_type : 'filers' indicates a filing company, 'relations' indicates a company parsed from the Exhibit 21 relationships
    * top_parent_id : calculated best guess of the cw_id at the top of the hierarchy this company is a part of
    * top_parent_id : calculated best guess of the cw_id at the top of the hierarchy this company is a part of
    * num_parents : number of known 'parent' companies that this company is a subsidiary of (calculated from company_relations)
    * num_children : number of known 'child' (subsidiary) companies that this company has (calculated from company_relations)




company_locations:

Each company may have multiple locations associated with it.  Filing companies usually have a business address, mailing address, and jurisdiction of incorporation. Subsidiary companies have a jurisdiction or operating location, but we don't know which one was parsed.  For international addresses the city, state, postal-code, and country fields are occasionally wrong.

    * location_id : row id for this record 
    * cw_id : id of the company this location belongs to      
    * date : date associated with this location (usually the date of filing it is parsed from)      
    * type : one of business, mailing, state_of_incorp  if the record was from a filer, otherwise relation_loc       
    * raw_address : Text version of address in unparsed form (in some cases parsed and re-assembled) 
    * street_1 : parsed first portion of address (usually only for filers)    
    * street_2 : parsed first portion of address (usually only for filers)     
    * city          
    * state : usually a two letter state code, sometimes a country name, or EDGAR country code (not the same as UN country code)        
    * postal_code  
    * country : null (uh oh)     
    * country_code : UN two letter country code that this address has been matched to  
    * subdiv_code : UN subdivision (province/state) code that this address has been matched to, if possible




company_names:

Each company (cw_id) may have multiple names associated with it.  These include both the original name from the SEC filing, as well as standardized "match names" that have most accents and punctuation removed and common terms abbreviated. Some companies will also include alternate former names.

    * name_id : the row id for this record
    * cw_id : id of company this name belongs to
    * name : name of this company (may include UTF8 chars)
    * date : a date associated with this name (usually the date of the filing)
    * source : one of filer_match_name (standardized), filer_conformed_name ("conformed" by SEC, but doesn't always follow rules),  cik_former_name (a former name for the company, matched by CIK), relationships_company_name (raw name from the Exhibit 21 filing), relationships_clean_company (standardized name from Exhibit 21 filing)
    * source_row_id : record id in the appropriate source table


company_relations:

This table gives the parent/child relationships as parsed from the Exhibit 21 of the 10-K where possible.  In many cases the parent is a "filing" company and the children are not.  But some Exhibit 21 filings indicated hierarchical relationships between subsidiaries that we were able to parse out.  
NOTE: Some groups of companies may form circular loops due to peculiarities of their filings (Same companies listed as parents and children), or because multiple CIKs refer to the same filing. 

    * relation_id : row id of this record
    * source_cw_id : cw_id of source or "parent" company for this relation
    * target_cw_id : cw_id of target/subsidary company for this relation
    * relation_type : not currently used
    * relation_origin : currently "relationships" indicating that it came from an Exhibit 21 filing
    * origin_id : row id in source table


filings:

Master list of company filings (currently only for 2008) downloaded from the SEC.  We are mostly interested in the 10-K filings

    * filing_id : row id for this record       
    * filing_date : date the SEC received the filing    
    * type : we are only interested in 10-K, and 10-K/A, but there are tons of other kinds...           
    * company_name : original from sec     
    * filename : path within edgar system to download the filing       
    * cik : SEC's id for the company making the filing USE THIS TO MATCH TO COMPANIES TABLE            
    * has_sec21 : indicates whether this filing includes an Exhibit 21 subsidiary information we want to parse      
    * year : the year the filing is for (not always the same as the filing date)           
    * quarter : quarter the filing is for        
    * has_html : (parsing diagnostic) Is the subsidiary data formatted in HTML?       
    * num_tables : (parsing diagnostic) If it is html, does it have tables?     
    * num_rows : (parsing diagnostic) How many rows of subsidiary data are there?       
    * tables_parsed : (parsing diagnostic) Indicates how many tables in the filing the parser actually read.
    * rows_parsed : (parsing diagnostic) Indicates how many rows in the filing the parser actually extracted data from.   
    * period_of_report : Official date this report describes (it may actually be filed later)
    * date_filed :  How is this different that filing_date?       
    * date_changed :  ?   
    * sec_21_url :  url to view the Exhibit 21 page of the filing, if there is one.  


sic_codes:

Gives textual descriptions of the industry classifications codes included in most filings to describe the primary business. This roughly corresponds to the codes at http://www.osha.gov/pls/imis/sicsearch.html, but the SEC seems to have some "special" variations, and in some places we filled in the description. 

    * sic_code : sic industry code, corresponds to "sic_category" in companies table. 
    * industry_name : description of category
    * sic_sector : code for higher-level sector this industry is included within


sic_sectors:

    * sic_sector : code for industry sector
    * sector_name : description of industry sector
    * sector_group : code for highest level industry group this sector is within
    * sector_group_name : description of highest level industry group


un_countries:

Wherever possible, we have matched the various types of address in the data to UN ISO-3166 standard country codes.

    * country_code : two letter UN country code
    * country_name : Name of country (some are modified slightly from UN standard)
    * row_id : id for this record
    * latitude : as returned by google's geocoding service (some are wrong)
    * longitude : as returned by google's geocoding service (some are wrong)



un_country_subdivisions:

Where possible, address are also matched at the state/province (subdivision) level within each country.  These codes are also from ISO-3166

    * country_code : country code this subdivision is part of 
    * subdivision_code : two or three letter code for this state or province
    * subdivision_name : name for the state or province
    * remarks : sometimes indicates alternate spelling, or that the entity has more than one record
    * row_id ; record id for this entry
    * dupe : ?  
    * latitude : as returned by google's geocoding service (some are wrong)
    * longitude : as returned by google's geocoding service (some are wrong)
