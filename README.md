# Check Your Culture (CHURU) 1.0.0

**CHURU** is a fast human cell line authenticator designed for any type of short-read sequencing data. For standard RNA-seq data, the program provides output in under 10 minutes.


---

## **Features**
- Rapid variant profiling using k-mer filtration.
- Cell line authentication based on CCLE reference SNP sets.
- Estimation of contamination levels based on variant allele frequencies.

---

## **Setup**

### **1. Clone the Repository**
```bash
git clone https://github.com/Dohun-Yi/churu.git
cd churu
```

### **2. Install Dependencies**
Install the required Python libraries and third-party tools:
```bash
pip install scipy pyfaidx
bash ./setup/install_[DEPENDENCIES].sh  # Installation scripts for VarScan, KMC, BWA, STAR, SAMtools
```

Ensure the following dependencies are installed:
- **Software**: `samtools>=1.0`, `VarScan==2.4.6`, `KMC>=3.2.0`, `STAR` (RNA mode), `BWA>=0.7.0` or `BWA-MEM2` (DNA mode)
- **Python Libraries**: `scipy>=0.14.0`, `pyfaidx`
- **Parallelization**: `GNU parallel>=20160622`
- **Linux Core Utilities**: `awk`, `wc`, `cut`, `split`


### **3. Download Required Resources**
To ensure compatibility with specific CCLE versions, download the required resources:  

**GENCODE Version Compatibility**
- **GENCODE v34**: for CCLE **22Q4** and **23Q2**
- **GENCODE v44**: for CCLE **23Q4** and later

**Resources for CCLE 22Q4 and GENCODE v34 (hg38)**
- **Genome and annotation:** [GENCODE v34 + hg38](https://www.gencodegenes.org/human/release_34.html)
  - Annotation (gtf): [download here](https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.annotation.gtf.gz)
  - Transcript (fa): [download here](https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/gencode.v34.transcripts.fa.gz)
  - Genome (fa): [download here](https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_34/GRCh38.primary_assembly.genome.fa.gz)

- **CCLE 22Q4:** [DepMap portal](https://depmap.org/portal/download/all/)  
  - Somatic Variants: *OmicsSomaticMutations.csv*
  - Expression Data: *OmicsExpressionProteinCodingGenesTPMLogp1.csv*
  - Model Files: *Model_v2.csv* or *Model.csv*

### **4. Prepare Resources**
Decompress and index the resources:
```bash
gzip -d gencode.v34.annotation.gtf.gz
gzip -d gencode.v34.transcripts.fa.gz
gzip -d GRCh38.primary_assembly.genome.fa.gz
samtools faidx GRCh38.primary_assembly.genome.fa
```

### **5. Build CHURU Reference**
Generate reference files for CHURU:
```bash
./churu_build \
    --transcript-fa gencode.v34.transcripts.fa      \
    --gtf gencode.v34.annotation.gtf                \
    --ccle-variant-file OmicsSomaticMutations.csv   \
    --genome-fa GRCh38.primary_assembly.genome.fa   \
    --output ./ChuruReference/
```

### **6. Create STAR or BWA Index** *(Optional)*
Skip this step if STAR or BWA index files are already available.
```bash
STAR    --runMode genomeGenerate   \
        --genomeFastaFiles GRCh38.primary_assembly.genome.fa    \
        --genomeDir GRCh38.primary_assembly.genome.fa_STAR      \
        --runThreadN 32
```

---

## **Usage**

### **7. Run CHURU**
Test CHURU on demo data:
```bash
./churu -1 demo/demo_1.fastq.gz \
        -2 demo/demo_2.fastq.gz \
        -o demo_output          \
        -r ChuruReference                       \
        -g GRCh38.primary_assembly.genome.fa    \
        -i GRCh38.primary_assembly.genome.fa_STAR           \
        -s OmicsSomaticMutations.csv                        \
        -e OmicsExpressionProteinCodingGenesTPMLogp1.csv    \
        -m Model.csv \
        -t 8
```

### **8. Check Results**
Inspect the output file:
```bash
head -n 3 demo_output/churu.out
```
Example output:
```
cell_id cell_name   patient_id  n_snp   frac_overlap    posterior   estimated_fraction
ACH-001086  HELA    PT-c34xau   5   71.43%  1.00    -
ACH-000648  NCIH28  PT-pVwyuS   1   14.29%  4.1e-14 -
```
**Output Format:**
- **`cell_id`**: DepMap ID of cell line
- **`cell_name`**: Name of cell line (if Model is provided)
- **`patient_id`**: Patient of origin (if Model is provided)
- **`n_snp`**: Detected SNPs from the data
- **`frac_overlap`**: Overlap fraction of detected SNPs
- **`posterior`**: Posterior probability of cell match (match if >= 0.5)
- **`estimated_fraction`**: Estimated contamination fraction if multiple matches


---

## **Contacts**
- **Dohun Yi** (kutarballoon@gmail.com)
- **Jin-Wu Nam** (jwnam@hanyang.ac.kr)
