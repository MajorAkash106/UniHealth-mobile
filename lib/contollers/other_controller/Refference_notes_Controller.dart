import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Refference_Notes_Controller extends GetxController{

  List<String> MNA_Ref_list =['Vellas B, Villars H, Abellan G, et al. Overview of the MNA® - Its History and Challenges. J Nutr Health Aging 2006;10:456-465.',
    'Rubenstein LZ, Harker JO, Salva A, Guigoz Y, Vellas B. Screening for Undernutrition in Geriatric Practice: Developing the Short-Form Mini Nutritional Assessment (MNA-SF). J. Geront 2001;56A: M366-377.',
    'Guigoz Y. The Mini-Nutritional Assessment (MNA®) Review of the Literature - What does it tell us? J Nutr Health Aging 2006; 10:466-487.',
    'Kaiser MJ, Bauer JM, Ramsch C, et al. Validation of the Mini Nutritional Assessment Short-Form (MNA®-SF): A practical tool for identification of nutritional status. J Nutr Health Aging 2009; 13:782-788.',
    '® Société des Produits Nestlé SA, Trademark Owners.',
    "© Société des Produits Nestlé SA 1994, Revision 2009.",
    "For more information: www.mna-elderly.com"
  ];

  List<String> Anthropomatry_Ref_list =["Ideal Body Weight:  IBW BASED ON BMI = 25KG/M2. (Singer P et al. Clin Nutr. 2019 Feb;38(1):48-79. doi: 10.1016/j.clnu.2018.08.037)",
    "Adjusted Body weight: Singer P et al. Clin Nutr. 2019 Feb;38(1):48-79. doi: 10.1016/j.clnu.2018.08.037",
    "Knee Height: Chumlea WC et al. J Am Geriatr Soc . 1985 Feb;33(2):116-20. doi: 10.1111/j.1532-5415.1985.tb02276.x",
    " MAMC: Ziegler TR. N Engl J Med . 2009 Sep 10;361(11):1088-97"
  ];

  List <String> Nutritional_Diagnosis_Ref_List=['1) T. Cederholm et al.Clinical Nutrition 34 (2015) 335-340; 2) D. Volkert et al. Clinical Nutrition 38 (2019) 10e47',
  '',
  ];


  //Under pal care
List <String> APKS_Ref_list=['Abernethy AP et al. 10.1186/1472-684X-4-7'];
List <String> SPICT_Ref_list=['1) De Bock R et al. DOI: 10.1089/jpm.2017.0205',
'2) Woolfied A et al. DOI: 10.1089/jpm.2018.0562'
];

//under status then
  List <String> ASCITES_Ref_list=['James, R. (1989), Nutritional support in alcoholic liver disease: a review. Journal of Human Nutrition and Dietetics, 2: 315-323. doi:10.1111/j.1365-277X.1989.tb00034.x',];

  List <String> AMPUTATION_Ref_list=[' Chumlea WC et al. J Am Geriatr Soc . 1985 Feb;33(2):116-20. doi: 10.1111/j.1532-5415.1985.tb02276.x'];
 List <String> StrongKid_Ref_list =['Ziegler TR. N Engl J Med . 2009 Sep 10;361(11):1088-97'];

 List <String> ESPEN_Ref_list =['1) T. Cederholm et al.Clinical Nutrition 34 (2015) 335-340; 2) D. Volkert et al. Clinical Nutrition 38 (2019) 10e47'];

 List <String> phenotypic_ref_list =['ASMI = APPENDICULAR SKELETAL MUSCLE INDEX','FFMI = FAT FREE MASS INDEX','BIA =BIOELECTRICAL IMPEDANCE ANALYSIS',
 'DXA=DUAL ENERGY X-RAY ABSORPTIOMETRY'
 ];

 List<String>Etological_ref_list=['ER = ENERGY REQUIREMENTS; Reduced assimilation of food/nutrients is associated with malabsorptive disorders like short bowel syndrome, pancreatic insufficiency and after bariatric surgery. It is also associated with disorders like esophageal strictures, gastroparesis, and intestinal pseudo-obstruction. Malabsorption is a clinical diagnosis manifest as chronic diarrhea or steatorrhea. Malabsorption in those with ostomies is evidenced by elevated volumes of output.',
 'Acute disease/injury-related. Severe inflammation is likely to be associated with major infection, burns, trauma or closed head injury. Other acute disease/injury-related conditions are likely to be associated with mild to moderate inflammation; 2) Chronic or recurrent mild to moderate inflammation is likely to be associated with malignant disease, chronic obstructive pulmonary disease, congestive heart failure,chronic renal disease, liver disease, rheumatoid arthritis or any disease with chronic or recurrent Inflammation. Note that transient inflammation of a mild degree does not meet the threshold for this etiologic criterion.'
 ];


  List <String> NRSREF =["Prototypes for severity of disease:Score=1: a patient with chronic disease, admitted to hospital due to complications. The patient is weak but out of bed regularly. Protein requirement is increased, but can be covered by oral diet or supplements in most cases.", "Score=2: a patient confined to bed due to illness, e.g. following major abdominal surgery. Protein requirement is substantially increased, but can be covered, although artificial feeding is required in many cases.", "Score=3: a patient in intensive care with assisted ventilation etc. Protein requirement is increased and cannot be covered even by artificial feeding. Protein breakdown and nitrogen loss can be significantly attenuated."];

List<String> ADULT_NON_ICU = ["SURGICAL: Weimann A et al. Clin Nutr. 2017;36(3):623-650\n ONCOLOGICAL: Arends J et al. Clin Nutr. 2017;36(5):1187-1196 \nPRESSURE ULCER: DOI: 10.37111/braspenj.diganaoalesao2020 \nELDERLY: Diretriz BRASPEN de terapia nutricional no envelhecimento. \nBRASPEN J 2019; 34 (Supl 3):2-58; D. Volkert et al. Clinical Nutrition 38 (2019) 10e47 \nGENERAL: Gomes F et al. Clin Nutr. 2018;37(1):336-353 \nCIRRHOSIS: Plauth M et al. Clin Nutr. 2019;38(2):485-521 \nKIDNEY DISEASE: Cano NJ. Clin Nutr. 2009;28(4):401-14; Ikizler TA et al. KDOQI clinical practice guideline for nutrition in CKD: 2020 update. Am J Kidney Dis. 2020;76(3)(suppl 1):S1-S107"];

List<String> ADULT_ICU = ['McClave SA et al. JPEN. 2016;40(2):159-211; van Zanten ARH et al. Crit Care. 2019 Nov 21;23(1):368; Singer P et al. Clin Nutr. 2019;38(1):48-79. doi: 10.1016/j.clnu.2018.08.037'];


List<String> pregAndLac = ['Institute of Medicine. Dietary Reference Intakes: The Essential Guide to Nutrient Requirements. Washington, DC. National Academies Press, 2006.'];

List<String> pediatrics = ['Kleinman RE. Pediatric nutrition handbook. 6a ed. Elk Grove Village: American Academy of the Pediatric; 2009. P.79-112 \nAgostoni C et al. J Pediatr Gastroenterol Nutr. 2010;50(1):85-91. \nASPEN Guidelines Task Force. JPEN J Parenter Enteral Nutr. 2002;26(1 Suppl):1SA-138SA. \nASPEN Guidelines. JPEN J Parenter Enteral Nutr. 2009;33(3):255-9.'];
List<String> abdomen_Gi_disfunction = ['No other cause than patients condition was detected = patients with gi disease,such as pancreatitis,inflamatory bowel,infectious diarrhea, and other conditions that could justify a gi adverse event',
'Patient did not accept the treatment : this could be chosen by patients or their family',
  'Reference: Reintam BA et al. Intensive Care Med. 2013;39(5):899-909. doi: 10.1007/s00134-013-2831-1'
];


}