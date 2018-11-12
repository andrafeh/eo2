param num_rows >= 2, integer;     # Number of rows
param num_cols >= 2, integer;     # Number of columns 
param pool_of_people integer; 
param links integer;

set PATIENT_DONOR_PAIRS    := 1 .. (pool_of_people)/2; 
set ROWS    := 1 .. num_rows;	  # set of rows
set COLUMNS := 1 .. num_cols;	  # set of columns
set L := 1 .. links;

param compatibility {ROWS, COLUMNS} >= 0;

var x {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} binary; 
var alpha_a {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} binary; 
var alpha_b {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} binary; 

# maximize sum of the exchanges
maximize DonorPairs: sum {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS} x[i,j];

# guarantee donor can only donate one kidney
subject to DonorLimit {j in PATIENT_DONOR_PAIRS}: sum {i in PATIENT_DONOR_PAIRS} x[i,j] <= 1;

# guarantee patient can only receive one kidney
subject to RecipientLimit {i in PATIENT_DONOR_PAIRS}: sum {j in PATIENT_DONOR_PAIRS} x[i,j] <= 1;

# ensures number of kidneys received by patient i matches the number of kidneys donated by donor i
subject to Compatibility {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS}: x[i,j] <= compatibility[i,j];

subject to Cycling {i in PATIENT_DONOR_PAIRS, j in PATIENT_DONOR_PAIRS, k in PATIENT_DONOR_PAIRS: i <> j and j <> k and i <> k}: x[i,j]+x[j,k] <= x[k,i]+1;