layout:
morningstar
|
--scripts
    |
    --1_extract_ftse100_tickets.pl      Downloads and prints url
    --2_extract_symbols_regex.pl        Extracts symbols from downloaded html
    --3_add_symbols_to_db.pl            TODO: Uploads symbols to sqlite db
    --update_db_ftse100_symbols.pl      TODO: All of the above in 1 script
--lib
    |
    --DB.pm                             TODO: SQLite for manipulating database
--db
    |
    --stocks.sqlite                     TODO: Database