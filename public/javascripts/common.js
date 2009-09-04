// JScript File

//const DEFAULT_COUNTRY_ID = '217';
//const DEFAULT_COUNTRY = 'United States'
//const DEFAULT_LANGUAGE_ID = '29';
//const DEFAULT_LANGUAGE = 'English';
//const PSP_FOREIGN_STATE_CODE = 'XX';
//const PSP_FOREIGN_STATE_TEXT = 'NON-US';

var currentStepName = 'Instructions';
var currentStepIndex = 0;
var currentStepChanged = false;


// PersonInfo Fields
var USCitizen;
var USResident;
var EnglishPrimaryYes;
var TOEFL;
var MELAB;
var IELTS;
var LanguageTestTranscript;
var NoLanguageTest;
var MilitaryServiceYes;
var SSNRow;
var CitizenCountryRow;
var MilitarySection;
var CountryOfCitizenship;
var SSN;
var SSNREV;
var SSNRFV;
var SSNVldtImg;
var LanguageRow;
var LanguageTestSection;
var TOEFLTestType;
var TOEFLTestId;
var TOEFLScore;
var TOEFLInfoRow;
var MELABScore;
var MELABInfoRow;
var IELTSScore;
var IELTSInfoRow;
var PrimaryLanguage;
var MilitaryStatusRow;
var CountryRFV;
var LanguageRFV;
var TOEFLTypeRFV;
var TOEFLTestIDRFV;
var TOEFLScoreRFV;
var MELABScoreRFV;
var IELTSScoreRFV;

var srcImgRequired = 'Images/Walden/Shared/validateOn.gif';
var srcImgNotRequired = 'Images/Walden/Shared/validateOff.gif';
var altImgRequired = '*';
var altImgNotRequired = '';

var showExclamationMarks = false;



/************************************************
DESCRIPTION: Init

PARAMETERS:
  
REMARKS: 

AUTHOR: Harry B Swartz II
*************************************************/+
function InitStep(sender, args) 
{   
    //intExpiration = 1 * 60 * 1000;
    //SetTimer();
    
    var prm = Sys.WebForms.PageRequestManager.getInstance();
    if (prm.get_isInAsyncPostBack())
    {
        args.set_cancel(true);
        //alert('Please wait till page finishes refreshing.');
        return;
    }
    var postbackElement = args.get_postBackElement();
    var postbackElementID = postbackElement.id;
    currentStepName = document.getElementById('ctl00_cphMain_CurrentStepName').value;
    nextStepName = document.getElementById('ctl00_cphMain_NextStepName').value;
    currentStepIndex = document.getElementById('ctl00_cphMain_CurrentStepIndex').value;
    currentStepChanged = false;
    var validateApplication = false;
    
    
    // figure out if app changed and if need to validate the whole app
    if (postbackElement.stepName != currentStepName)
    {   
        if (postbackElement.stepName != 'Review and Submit')
        { 
            if (postbackElementID.indexOf('SideBarList_ctl') > -1)
            {
                currentStepChanged = true;
            }
            else if (postbackElementID.indexOf('btnStart') > -1)
            {
                currentStepChanged = true;
            }
            else if (postbackElementID.indexOf('btnFinish') > -1)
            {
                currentStepChanged = true;
            }
            else if (postbackElementID.indexOf('btnNext') > -1)
            {
                currentStepChanged = true;
                if (nextStepName == 'Review and Submit')
                {
                    validateApplication = true;
                }
            }
            else if (postbackElementID.indexOf('btnPrevious') > -1 || postbackElementID.indexOf('btnFinishPrevious') > -1)
            {
                currentStepChanged = true;
            }
        }
        else
        {
            currentStepChanged = true;
            validateApplication = true;
        }
    }
        
        
    // process    
    if (currentStepChanged)
    {
        if (!validateApplication)
        {
            //var table = document.getElementById('StepDisplay');
            var continueIfInvalid;
            switch (currentStepName)
            {
                case "Instructions":
                    continueIfInvalid = false;
                    break;
                case "Review and Submit":
                    continueIfInvalid = postbackElementID.indexOf('btnFinish') == -1;
                    break;
                default:
                    continueIfInvalid = true;
                    break;
            }
            if (!ValidateCurrentPage(continueIfInvalid, true, args.get_request()))
            {
                //prm.abortPostBack();
                args.set_cancel(true);
                showExclamationMarks = true;
            }
        }
        else
        {
            var menuItem;
            var menuItemName;
            var menuImageName;
            var menuImage;
            
            if (ValidateCurrentPage(false, true, args.get_request()))
            {
                // loop though all the steps to see if they have been comleted
                for (var i = 0;;i++)
                {
                    if (i != currentStepIndex)
                    {
                        menuItemName = 'ctl00_cphMain_ApplicationSteps_SideBarContainer_SideBarList_ctl';
                        if (i < 10)
                        {
                            menuItemName = menuItemName + '0';
                        }
                        menuImageName = menuItemName;
                         
                        menuItemName = menuItemName + i + '_SideBarButton';
                        menuImageName = menuImageName + i + '_imgCompleted';
                        
                        menuItem = document.getElementById(menuItemName);
                        menuImage = document.getElementById(menuImageName);
                        if (menuItem == null || typeof(menuItem) == 'undefined')
                        {
                            break;
                        }
                        
                        if (menuItem.stepName != 'Review and Submit' && menuItem.IsRequired.toLowerCase() == 'true' && menuImage.src.indexOf("check.gif") == -1)
                        {
                            //args.set_cancel(true);
                            var control = document.getElementById('ctl00_cphMain_FailedStepName');
                            control.value=menuItem.stepName;
                            showExclamationMarks = true;
                            args.get_request().set_body(args.get_request().get_body().replace('FailedStepName=&', 'FailedStepName=' + menuItem.stepName + '&'));
                            break;
                        }
                    }
                }
            }
            else
            {
                args.set_cancel(true);
                //showExclamationMarks = true;
            }
            
        }
    }
}

/************************************************
DESCRIPTION: Init

PARAMETERS:
  
REMARKS: 

AUTHOR: Harry B Swartz II
*************************************************/
function LoadedStep(sender, args) 
{
    currentStepName = document.getElementById('ctl00_cphMain_CurrentStepName').value;
    currentStepIndex = document.getElementById('ctl00_cphMain_CurrentStepIndex').value;
    //currentStepChanged = document.getElementById('ctl00_cphMain_CurrentStepHasChanged').value == 'True' ? true : false;
    //if (currentStepChanged)
    //{
        switch (currentStepName)
        {
            case "Instructions":
                break;
            case "Personal Information":
                InitPersonInfoPage();
                break;
            case "Academic Information":
                InitEducationPage();
                break;
            case "Employment Information":
                InitEmploymentPage();
                break;
//            case "Goal Statement":
//                InitGoalStatementPage();
//                break;
            case "Review and Submit":
                InitReviewAndSubmitPage();
                break;
            case "Next Steps":
                InitNextStepsPage();
                break;
            case "Offer of Acceptance":
                InitOfferLetter();
                break;
            //default:
              //  alert('Invalid Page Index');    
        }
        window.scroll(0,0); 
   // }
   
   if (showExclamationMarks)
   {
       Page_ClientValidate(null);   
   }
   
   
   showExclamationMarks = false;
}

function InitReviewAndSubmitPage()
{
    var paymmentOption = GetControl(null, "rdblPaymentMethod_0", 6);
    if (paymmentOption != null)
    {
        ToggleCreditCardFields(paymmentOption.checked);
    }
}

function ToggleCreditCardFields(show)
{
    var DisclaimerRow = document.getElementById('DisclaimerRow');
    var CheckBoxRow = document.getElementById('CheckBoxRow');
    var CCTypeRow = document.getElementById('CCTypeRow');
    var CCNumberRow = document.getElementById('CCNumberRow');
    var CCSecurityCodeRow = document.getElementById('CCSecurityCodeRow');
    var CCExpirationRow = document.getElementById('CCExpirationRow');
    var CCNameRow = document.getElementById('CCNameRow');
    var rfvFeeAgreement = GetControl(null, "rfvFeeAgreement", 6);
    var rfvCardType = GetControl(null, "rfvCardType", 6);
    var rfvCardNumber = GetControl(null, "rfvCardNumber", 6);
    var rfvSecurityCode = GetControl(null, "rfvSecurityCode", 6);
    var rfvExpirationDate = GetControl(null, "rfvExpirationDate", 6);
    var rfvNameOnCard = GetControl(null, "rfvNameOnCard", 6);
    
    if (show)
    {
        ShowRow(DisclaimerRow);
        ShowRow(CheckBoxRow);
        ShowRow(CCTypeRow);
        ShowRow(CCNumberRow);
        ShowRow(CCSecurityCodeRow);
        ShowRow(CCExpirationRow);
        ShowRow(CCNameRow);
    }
    else
    {
        HideRow(DisclaimerRow);
        HideRow(CheckBoxRow);
        HideRow(CCTypeRow);
        HideRow(CCNumberRow);
        HideRow(CCSecurityCodeRow);
        HideRow(CCExpirationRow);
        HideRow(CCNameRow);
    }
    
    EnableValidator(rfvFeeAgreement, show);
    EnableValidator(rfvCardType, show);
    EnableValidator(rfvCardNumber, show);
    EnableValidator(rfvSecurityCode, show);
    EnableValidator(rfvExpirationDate, show);
    EnableValidator(rfvNameOnCard, show);
}

function InitOfferLetter()
{
    var AdmissionStatus = document.getElementById('ctl00_cphMain_AdmissionStatus');
    var DecisionRow = document.getElementById('DecisionRow');
    
   
    if (AdmissionStatus.value == 'DN' || AdmissionStatus.value == 'NQ')
    {
        HideRow(DecisionRow);   
    }
    else
    {
        ShowRow(DecisionRow);
    }
}

function InitPersonInfoPage()
{
    LoadPersonInfoPageControls();

    // init UsCitizenFields
    
    var citizenStatus;
    if (USCitizen)
    {
        citizenStatus = 'US'
    }
    else if (USResident)
    {
        citizenStatus = 'PR';
    }
    else
    {
        citizenStatus = 'NR';
    }
    ToggleUSCitizenFields(citizenStatus);
    
    // Init Language options
    if (EnglishPrimaryYes.checked)
    {
        ToggleLanguageFields(true);
    }
    else
    {
        
        //ToggleLanguageFields(false);
        
        // init language test scores
        if (TOEFL.checked)
        {
            ToggleLanguageTestFields("TOEFL");
        }
        else if (MELAB.checked)
        {
            ToggleLanguageTestFields("MELAB");
        }
        else if (IELTS.checked)
        {
            ToggleLanguageTestFields("IELTS");
        }
        else if (LanguageTestTranscript.checked)
        {
            ToggleLanguageTestFields("Transcript");
        }
        else if (NoLanguageTest.checked)
        {
            ToggleLanguageTestFields("NA");
        }   
       
    }
    
    // init State / province fields
    if (USCitizen)
    {        
        // init Military options
        if (MilitaryServiceYes.checked)
        {
            ToggleMilitaryFields(true);
        }
        else
        {
            ToggleMilitaryFields(false);
        }
    }
    
    ToggleAddressFields(GetControl(null, "Country", 2, null, "ShippingAddress", 0));
    ToggleAddressFields(GetControl(null, "Country", 2, null, "MailingAddress", 0));
    ToggleAddressFields(GetControl(null, "Country", 2, null, "BillingAddress", 0));
    
    ToggleAddressType("ShippingAddress","MailingAddress");
    ToggleAddressType("BillingAddress","MailingAddress");
}

function ToggleUSCitizenFields(value) 
{	       
    switch (value)
	{
		case "US":
		    HideRow(CitizenCountryRow);
		    CountryOfCitizenship.value = "";
		    EnableValidator(CountryRFV, false);
		    ShowRow(SSNRow);
		    EnableValidator(SSNRFV, false);
		    EnableValidator(SSNREV, true);
		    SSNVldtImg.src = srcImgNotRequired;
		    SSNVldtImg.alt = altImgNotRequired;
		    ShowRow(MilitarySection);
			break;
		case "PR":
			ShowRow(CitizenCountryRow);
			EnableValidator(CountryRFV, true);
			ShowRow(SSNRow);
			EnableValidator(SSNRFV, false);
		    EnableValidator(SSNREV, true);
		    SSNVldtImg.src = srcImgNotRequired;
		    SSNVldtImg.alt = altImgNotRequired;
			HideRow(MilitarySection);
			break;
		case "NR":
			ShowRow(CitizenCountryRow);
			EnableValidator(CountryRFV, true);
			SSN.value = '';
			HideRow(SSNRow);
			EnableValidator(SSNRFV, false);
		    EnableValidator(SSNREV, false);
		    SSNVldtImg.src = srcImgNotRequired;
		    SSNVldtImg.alt = altImgNotRequired;
			HideRow(MilitarySection);
			break;
		default:
		    alert("Bad value passed to ToggleUSCitizenFields");
	}
}


function ToggleLanguageFields(value) 
{	
    if (value)
    {
        HideRow(LanguageRow);
        EnableValidator(LanguageRFV, false);
        PrimaryLanguage.value="";
        HideRow(LanguageTestSection);
        if (TOEFL.checked)
        {
            TOEFLTestType.value="";
            EnableValidator(TOEFLTypeRFV, false);
            TOEFLTestId.value="";
            EnableValidator(TOEFLTestIDRFV, false);
            TOEFLScore.value="";
            EnableValidator(TOEFLScoreRFV, false);
            HideRow(TOEFLInfoRow);
            TOEFL.checked=false;
        }
        else if (MELAB.checked)
        {
            MELABScore.value="";
            EnableValidator(MELABScoreRFV, false);
            HideRow(MELABInfoRow);
            MELAB.checked = false;
        }
        else if (IELTS.checked)
        {
            IELTSScore.value="";
            EnableValidator(IELTSScoreRFV, false);
            HideRow(IELTSInfoRow);
            IELTS.checked = false;
        }
        else if (LanguageTestTranscript.checked)
        {
            LanguageTestTranscript.checked = false
        }
        else if (NoLanguageTest.checked)
        {
            NoLanguageTest.checked = false;
        } 
    }
    else
    {
        HideRow(MELABInfoRow);
        HideRow(TOEFLInfoRow);
        HideRow(MELABInfoRow);
        HideRow(IELTSInfoRow);
        
        if (!LanguageTestTranscript.checked)
            NoLanguageTest.checked = true;
        
        ShowRow(LanguageRow);
        EnableValidator(LanguageRFV, true);
        ShowRow(LanguageTestSection);
    }
}

function ToggleAddressFields(control)
{ 
    var State = document.getElementById(control.id.replace("Country", "State"));
    var Province = document.getElementById(control.id.replace("Country", "Province"));
    var StateRFV = document.getElementById(control.id.replace("Country", "rfvState"));
    var ProvinceRFV = document.getElementById(control.id.replace("Country", "rfvProvince"));
    var StateRow = State.parentNode.parentNode;
    var ProvinceRow = Province.parentNode.parentNode;
    
    if (control.value == "US")
    {
        ShowRow(StateRow);
        EnableValidator(StateRFV, true);    
        HideRow(ProvinceRow);
        Province.value = "";
        EnableValidator(ProvinceRFV, false);
    }
    else
    {
        ShowRow(ProvinceRow);
        EnableValidator(ProvinceRFV, false);
        HideRow(StateRow);
        State.value = "";
        EnableValidator(StateRFV, false);
    }
} 

function ToggleAddressType(Control,Default)
{
    var AddressLine1 = GetControl(null, "Line1", 2, null, Control, 0);
    var AddressLine2 = GetControl(null, "Line2", 2, null, Control, 0);
    var City = GetControl(null, "City", 2, null, Control, 0);
    var State = GetControl(null, "State", 2, null, Control, 0);
    var Province = GetControl(null, "Province", 2, null, Control, 0);
    var PostalCode = GetControl(null, "PostalCode", 2, null, Control, 0);
    var Country = GetControl(null, "Country", 2, null, Control, 0);
    
    var AddressLine1Row = AddressLine1.parentNode.parentNode;
    var AddressLine2Row = AddressLine2.parentNode.parentNode;
    var CityRow = City.parentNode.parentNode;
    var StateRow = State.parentNode.parentNode;
    var ProvinceRow = Province.parentNode.parentNode;
    var PostalCodeRow = PostalCode.parentNode.parentNode;
    var CountryRow = Country.parentNode.parentNode;
    
   
    var rfvAddressLine1 = GetControl(null, "rfvStreetAddress1", 2, null, Control, 0);
    var rfvAddressLine2 = GetControl(null, "rfvStreetAddress2", 2, null, Control, 0);
    var rfvCity = GetControl(null, "rfvCity", 2, null, Control, 0);
    var rfvState = GetControl(null, "rfvState", 2, null, Control, 0);
    var rfvProvince = GetControl(null, "rfvProvince", 2, null, Control, 0);
    var rfvPostalCode = GetControl(null, "rfvZip", 2, null, Control, 0);
    var rfvCountry = GetControl(null, "rfvCountry", 2, null, Control, 0);
    
    var DefaultAddressLine1 = GetControl(null, "Line1", 2, null, Default, 0);
    var DefaultAddressLine2 = GetControl(null, "Line2", 2, null, Default, 0);
    var DefaultCity = GetControl(null, "City", 2, null, Default, 0);
    var DefaultState = GetControl(null, "State", 2, null, Default, 0);
    var DefaultProvince = GetControl(null, "Province", 2, null, Default, 0);
    var DefaultPostalCode = GetControl(null, "PostalCode", 2, null, Default, 0);
    var DefaultCountry = GetControl(null, "Country", 2, null, Default, 0);
    
    var TitleRow = document.getElementById("row" + Control);
    
    var Checkbox = GetControl(null,"chk" + Control,2);
    
    if (Checkbox.checked)
    {
        ShowRow(TitleRow);
        ShowRow(AddressLine1Row);
        ShowRow(AddressLine2Row);
        ShowRow(CityRow);
        if (Country.value == "US")
        {
            ShowRow(StateRow);
        }
        else
        {
            ShowRow(ProvinceRow);
        }
        ShowRow(PostalCodeRow);
        ShowRow(CountryRow);
        
        EnableValidator(rfvAddressLine1,true);
        EnableValidator(rfvCity,true);
        
        if (Country.value == "US")
        {
            EnableValidator(rfvState,true);
        }
        else
        {
            EnableValidator(rfvProvince,true);
        }
        
        EnableValidator(rfvPostalCode,true);
        EnableValidator(rfvCountry,true); 
    }
    else
    {
        HideRow(TitleRow);
        HideRow(AddressLine1Row);
        HideRow(AddressLine2Row);
        HideRow(CityRow);
        HideRow(StateRow);
        HideRow(ProvinceRow);
        HideRow(PostalCodeRow);
        HideRow(CountryRow);
        
        AddressLine1.value = DefaultAddressLine1.value;
        AddressLine2.value = DefaultAddressLine2.value;
        City.value = DefaultCity.value;
        State.selectedIndex = DefaultState.selectedIndex;
        Province.value = DefaultProvince.value;
        PostalCode.value = DefaultPostalCode.value;
        Country.selectedIndex = DefaultCountry.selectedIndex;
        
        EnableValidator(rfvAddressLine1,false);
        EnableValidator(rfvCity,false);
        EnableValidator(rfvState,false);
        EnableValidator(rfvPostalCode,false);
        EnableValidator(rfvCountry,false);        
    }    
}

function ToggleLanguageTestFields(value) 
{	
    switch (value)
    {
        case "TOEFL":
            ShowRow(TOEFLInfoRow);
            HideRow(MELABInfoRow);
            MELABScore.value="";
            HideRow(IELTSInfoRow);
            IELTSScore.value="";
            EnableValidator(TOEFLTypeRFV, true);
            EnableValidator(TOEFLTestIDRFV, true);
            EnableValidator(TOEFLScoreRFV, true);
            EnableValidator(MELABScoreRFV, false);
            EnableValidator(IELTSScoreRFV, false);
            break;
        case "MELAB":
            HideRow(TOEFLInfoRow);
            TOEFLTestType.value = "";
            TOEFLTestId.value = "";
            TOEFLScore.value = "";
            ShowRow(MELABInfoRow);
            HideRow(IELTSInfoRow);
            IELTSScore.value="";
            EnableValidator(TOEFLTypeRFV, false);
            EnableValidator(TOEFLTestIDRFV, false);
            EnableValidator(TOEFLScoreRFV, false);
            EnableValidator(MELABScoreRFV, true);
            EnableValidator(IELTSScoreRFV, false);
            break;
        case "IELTS":
            HideRow(TOEFLInfoRow);
            TOEFLTestType.value = "";
            TOEFLTestId.value = "";
            TOEFLScore.value = "";
            HideRow(MELABInfoRow);
            MELABScore.value="";
            ShowRow(IELTSInfoRow);
            EnableValidator(TOEFLTypeRFV, false);
            EnableValidator(TOEFLTestIDRFV, false);
            EnableValidator(TOEFLScoreRFV, false);
            EnableValidator(MELABScoreRFV, false);
            EnableValidator(IELTSScoreRFV, true);
            break;
        default:
            HideRow(TOEFLInfoRow);
            TOEFLTestType.value = "";
            TOEFLTestId.value = ""; 
            TOEFLScore.value = "";
            HideRow(MELABInfoRow);
            MELABScore.value="";
            HideRow(IELTSInfoRow);
            IELTSScore.value="";
            EnableValidator(TOEFLTypeRFV, false);
            EnableValidator(TOEFLTestIDRFV, false);
            EnableValidator(TOEFLScoreRFV, false);
            EnableValidator(MELABScoreRFV, false);
            EnableValidator(IELTSScoreRFV, false);
            break;
    }
}

function ToggleMilitaryFields(value) 
{
    if (value)
    {
        ShowRow(MilitaryStatusRow);
    }
    else
    {
        HideRow(MilitaryStatusRow);
        // blank out fields
        var MilitaryStatusActive = GetControl(null, "rdblMilitaryStatus_0", 2);
        MilitaryStatusActive.checked = true;
    }
}

function InitEducationPage()
{
    // toggle province state
    for (var i = 0;; i+=2)
    {
        var control = GetControl(null, "Country", 3, null, "College", i);
        if (control == null)
        {
            break;
        }
        ToggleAddressFields(control);
    }
}
 
function InitEmploymentPage()
{
    
//    if (GetControl(null, "rdblEmploymentExperienceFormUpload_1", 4).checked)
//    {
//        ToggleResumeUpload(true, false);
//    }
//    else
//    {
//        ToggleResumeUpload(false, false);
        
        // toggle province state
        for (var i = 0;; i+=2)
        {
            var control = GetControl(null, "Country", 4, null, "Employers", i);
            if (control == null)
            {
                break;
            }
            ToggleAddressFields(control);
        }
//    }  
    
    var Program = document.getElementById('ctl00_cphMain_Program').value;
    var CertificationAcknowledgementSection = document.getElementById("EducationCertificationAcknowledgement");
    var RFV = GetControl(null, "rfvPersonalCertificationLicensureResponsibilityAcknowledgement", 4);
    var checkbox = GetControl(null, "chkPersonalCertificationLicensureResponsibilityAcknowledgement", 4);
    
    if (Program.indexOf('W1PSY') > -1)
    {
        ShowRow(CertificationAcknowledgementSection);
        EnableValidator(RFV, true);
    }
    else
    {
        HideRow(CertificationAcknowledgementSection);
        EnableValidator(RFV, false);
        checkbox.checked = false;
    }
    
    TogglePhoneEmail();       
   
}

function ToggleResumeUpload(value, flush)
{
    var uploadRow = document.getElementsByName("UploadRow");
    
    if (value)
    {
        for (var i = 0; i < uploadRow.length; i++)
        {
            ShowRow(uploadRow[i]);
        }
        ShowDataList("Employer ", false);
        if (flush)
        {
            //PageMethods.DeleteTable("Employers");
        }
    }
    else
    {
        for (var j = 0; j < uploadRow.length; j++)
        {
            HideRow(uploadRow[j]);
        }
        if (flush)
        {
            //PageMethods.DeleteUploadedFile("Resume");
        }
        ShowDataList("Employer ", true);
    }
}

function ToggleCurrentFile(display,type)
{
    if (display)
        document.getElementById("FileUploadedMessages").style.display = 'inline';
    else
        document.getElementById("FileUploadedMessages").style.display = 'none';
}


function InitGoalStatementPage()
{
    if (GetControl(null, "rdblEmploymentExperienceFormUpload_1", 5).checked)
    {
        ToggleGoalsUpload(true);
    }
    else
    {
        ToggleGoalsUpload(false);
    }
}

function ToggleGoalsUpload(value)
{
    var uploadRow = document.getElementsByName("UploadRow");
    var goalsRow = document.getElementsByName("GoalsRow");
    //var goals = GetControl(null, "txtGoalStatement", 5);
    //var goalsRFV = GetControl(null, "rfvGoalStatement", 5);
    
    if (value)
    {
        for (var i = 0; i < uploadRow.length; i++)
        {
            ShowRow(uploadRow[i]);
        }
        
        
        for (var j = 0; j < goalsRow.length; j++)
        {
            HideRow(goalsRow[j]);
        }
        
        //goals.value = "";
        //EnableValidator(goalsRFV, false);
        
    }
    else
    {
        for (var k = 0; k < uploadRow.length; k++)
        {
            HideRow(uploadRow[k]);
        }
        
             
        for (var l = 0; l < goalsRow.length; l++)
        {
            ShowRow(goalsRow[l]);
        }
        
        //EnableValidator(goalsRFV, false);  
        
    }
}

function InitNextStepsPage()
{
    var intStep = 0;
    // determine step
    while (GetControl(null,'spnNextStepsEnglishTestScores',intStep) == null && intStep < 100)
    {
        intStep++;
    }
    
    try // This removes the change program link for the next steps page
    {
        document.getElementById('ctl00_cphMain_ApplicationSteps_SideBarContainer_Callouts_hrefChangeStartDate').style.display = 'none';
    }
    catch(err)
    {
        // Do Nothing
    }

    
    if (document.getElementById('ctl00_cphMain_IsEnglishPrimary').value == 'True')
    {
        GetControl(null,'spnNextStepsEnglishTestScores',intStep).style.display = 'none';  
    }

    if (document.getElementById('ctl00_cphMain_HasCollege').value != 'True')
        GetControl(null,'spnNextStepsTranscripts',intStep).style.display = 'none';

//    if (document.getElementById('ctl00_cphMain_HasGoalStatement').value == 'True')
//        GetControl(null,'spnNextStepsGoalStatement',intStep).style.display = 'none';

    if (document.getElementById('ctl00_cphMain_PaymentMethod').value != 'Credit Card')
    {
        GetControl(null,'spnNextStepsPayByCheck',intStep).style.display = 'none';
        GetControl(null,'spnCreditCard',intStep).style.display = 'none';
    }
   
    if (document.getElementById('ctl00_cphMain_HasCertification').value == 'null' || document.getElementById('ctl00_cphMain_HasCertification').value == 'False')
        GetControl(null,'spnNextStepsCertifications',intStep).style.display = 'none';

    if (document.getElementById('ctl00_cphMain_BillingState').value != 'TN')
        GetControl(null,'spnNextStepsTNRequiredForm',intStep).style.display = 'none';

    if (document.getElementById('ctl00_cphMain_BillingState').value != 'AZ')
        GetControl(null,'spnNextStepsAZRequiredForm',intStep).style.display = 'none';

    if (document.getElementById('ctl00_cphMain_HasExamScores').value != 'True')
        GetControl(null,'spnNextStepsExams',intStep).style.display = 'none';
    
    document.getElementById('spnPayByCheckAttention').innerHTML = document.getElementById('ctl00_cphMain_CurrentSchool').value;
    //document.getElementById('spnTranscriptsAttention').innerHTML = document.getElementById('ctl00_cphMain_CurrentSchool').value;
 
}


/************************************************
DESCRIPTION: Used to get a sibling control.

PARAMETERS:
   masterControl - the control
   detailControlName - the name of the sibling
   stepOrdinal - the name of the step containing the control
   sectionName - the name of the section containing the control
   listControlName - List Control name
   row - row control is in 
  
REMARKS: 

AUTHOR: Harry B Swartz II
*************************************************/
function GetControl(masterControl, detailControlName, stepOrdinal, sectionName, listControlName, row)
{
    return document.getElementById(GetControlName(detailControlName, stepOrdinal, sectionName, listControlName, row));  
}

/************************************************
DESCRIPTION: Used to contruct the name of the control.

PARAMETERS:
   masterControl - the control
   detailControlName - the name of the sibling
   stepOrdinal - the name of the step containing the control
   sectionName - the name of the section containing the control
   listControlName - List Control name
   row - row control is in 
  
REMARKS: 

AUTHOR: Harry B Swartz II
*************************************************/
function GetControlName(controlName, stepOrdinal, sectionName, listControlName, row)
{
    var name;
    name = 'ctl00_cphMain_ApplicationSteps_ctl';
    
    if (stepOrdinal < 10)
    {
        name = name + '0';
    }
       
    name = name + stepOrdinal + "_";
    
    if (listControlName != null)
    {
        name = name + listControlName + "_ctl";
        if (row < 10)
        {
            name = name + '0';
        }
        
        name = name + row + "_";
    }
    
    name = name + controlName;
    return name;  
}


function ShowRow(row, tagID)
{
    if (row.style.display == 'none' || row.style.display == 'hidden')
    {
        row.style['display'] = 'inline'
        //IncrementRowspan(tagID, 1);
    }
}

function HideRow(row, tagID)
{
    if (row != null)
    {
        if (row.style.display == 'inline' || row.style.display == '')
        {
            row.style['display'] = 'none'
            //IncrementRowspan(tagID, -1);
        }
    }
}

function ShowDataList(dataListName, show)
{
    var newDisplay;
    if (show)
    {
        newDisplay = 'inline';
    }
    else
    {
        newDisplay = 'none';
    }
    var arrTr = document.getElementsByTagName('tr');
    
    for (i=0; i < arrTr.length; i++)
    {
	    if (arrTr[i].innerHTML.indexOf('Segment: ' + dataListName) > 0 && arrTr[i].innerHTML.indexOf('Segment: ' + dataListName) < 10)
	    {
    		
		    with(arrTr[i].style)
		    {
			    if(display != newDisplay)
			    {
				    arrTr[i].style.display = newDisplay;
				}
		    }
	    }
    }
}

function ValidateCurrentPage(continueIfInvalid, checkMenu, request)
{
    var isValid = true;
    //if (selectedStepChanged)
    //{  
        if (typeof(checkMenu) == "undefined")
        {
            checkMenu= true;
        }
        if (continueIfInvalid)
        {
            isValid = ValidateValidators();
        }
        else
        {
            if (typeof(Page_ClientValidate) != "undefined")
            {
                isValid = Page_ClientValidate(null);
            }
        }
         
        if (isValid)
        {
            if (checkMenu)
            {
                MarkStepComplete(request);
            }
        }
        else
        {
            UnMarkStepComplete(request);
        }
        
        
        return isValid || continueIfInvalid;
    //}  
}

function ValidateValidators()
{
    if (typeof(Page_Validators) != "undefined")
    {
        for (i = 0; i < Page_Validators.length; i++) 
        {
            var val = Page_Validators[i];
            if (typeof(val.enabled) == "undefined" || val.enabled != false)
            {
                if (typeof(val.evaluationfunction) == "function") 
                {
                    if (!val.evaluationfunction(val))
                    {
                        return false;
                    }
                }
            }
        }
    }
    return true;
}

function MarkStepComplete(request)
{
    document.getElementById('ctl00_cphMain_CurrentStepCompleted').value = "true";
    request.set_body(request.get_body().replace('CurrentStepCompleted=&', 'CurrentStepCompleted=true&'));
    request.set_body(request.get_body().replace('CurrentStepCompleted=false&', 'CurrentStepCompleted=true&'));
}

function UnMarkStepComplete(request)
{
    document.getElementById('ctl00_cphMain_CurrentStepCompleted').value = "false";
    request.set_body(request.get_body().replace('CurrentStepCompleted=&', 'CurrentStepCompleted=false&'));
    request.set_body(request.get_body().replace('CurrentStepCompleted=true&', 'CurrentStepCompleted=false&'));
}

function LoadPersonInfoPageControls()
{
    // init variables
    USCitizen = document.getElementById('ctl00_cphMain_IsUSCitizen').value == 'True' ? true : false;
    USResident = document.getElementById('ctl00_cphMain_IsUSResident').value == 'True' ? true : false;
    EnglishPrimaryYes = GetControl(null, "rdblEnglishPrimary_0", 2);
    TOEFL = GetControl(null, "rbEnglishProficiencyTOEFL", 2);
    MELAB = GetControl(null, "rbEnglishProficiencyMELAB", 2);
    IELTS = GetControl(null, "rbEnglishProficiencyIELTS", 2);
    LanguageTestTranscript = GetControl(null, "rdbEnglishProficiencyTranscript", 2);
    NoLanguageTest = GetControl(null, "rbEnglishProficiencyNull", 2);
    MilitaryServiceYes = GetControl(null, "rdblMilitaryService_0", 2);
    SSNRow = document.getElementById("SSNRow");
    SSN = GetControl(null, "txtSSN", 2);
    SSNRFV = GetControl(null, "rfvSSN", 2);
    SSNREV = GetControl(null, "revValidSSN", 2);
    SSNVldtImg = GetControl(null,"vldtSSN",2);
    CitizenCountryRow = document.getElementById("CountryOfCitizenshipRow");
    MilitarySection = document.getElementById("MilitaryServiceInformation");
    CountryOfCitizenship = GetControl(null, "ddlCountryOfCitizenship", 2);
    LanguageRow = document.getElementById("LanguageRow");
    LanguageTestSection = document.getElementById("EnglishProficiencyInformation");
    TOEFLTestType = GetControl(null, "ddlTOEFLTestType", 2);
    TOEFLTestId = GetControl(null, "txtTOEFLTestId", 2);
    TOEFLScore = GetControl(null, "txtTOEFLScore", 2);
    TOEFLInfoRow = document.getElementById("TOEFLInfoRow");
    MELABScore = GetControl(null, "txtMELABScore", 2);
    MELABInfoRow = document.getElementById("MELABInfoRow");
    IELTSScore = GetControl(null, "txtIELTSScore", 2);
    IELTSInfoRow = document.getElementById("IELTSInfoRow");
    PrimaryLanguage = GetControl(null, "ddlPrimaryLanguage", 2);
    MilitaryStatusRow = document.getElementById("MilitaryStatusRow");
    CountryRFV = GetControl(null, "rfvCountryOfCitizenship", 2);
    
    LanguageRFV = GetControl(null, "rfvPrimaryLanguage", 2);
    TOEFLTypeRFV = GetControl(null, "rfvTOEFLTestType", 2);
    TOEFLTestIDRFV = GetControl(null, "rfvTOEFLTestId", 2);
    TOEFLScoreRFV = GetControl(null, "rfvTOEFLScore", 2);
    MELABScoreRFV = GetControl(null, "rfvMELABScore", 2);
    IELTSScoreRFV = GetControl(null, "rfvIELTSScore", 2);
}


function IncrementRowspan(tagID, size)
{
    var column;
    column = document.getElementById(tagID + "1");
    column.rowspan = column.rowspan + size;
    column = document.getElementById(tagID + "2");
    column.rowspan = column.rowspan + size;
}

function ValidateDatesAttendedCollege(control,args)
{
    // get row
    var temp1 = control.id.lastIndexOf("ctl");
    var temp2 = control.id.indexOf("_", temp1);
    var row = parseInt(control.id.substring(temp1 + 3, temp2));
    
    var StartMonth = GetControl(null, "StartMonth", 3, null, "College", row);
    var StartYear = GetControl(null, "StartYear", 3, null, "College", row);
    var EndMonth = GetControl(null, "EndMonth", 3, null, "College", row);
    var EndYear = GetControl(null, "EndYear", 3, null, "College", row);
   
    if (EndYear.value == "" && EndMonth.value == "")
    {
        return args.IsValid = true;
    }
    else if (EndYear.value == "" || EndMonth.value == "")
    {
        return args.IsValid = false;
    }
    else if (StartYear.value > EndYear.value)
    {
        return args.IsValid = false;
    }
    else if (StartYear.value == EndYear.value)
    {
       return args.IsValid = (parseInt(EndMonth.value) >= parseInt(StartMonth.value));
    }
    else
    {
        return args.IsValid = true;
    }
    
}

function ValidateAdmissionsPolicy(control,args)
{
    var checkbox = GetControl(null, "chkAdmissionsPolicies", 1);
    
    if (checkbox != null)
    {
        return args.IsValid = checkbox.checked;
    }
    return args.IsValid = true;
}

function ValidateFeeAgreement(val, args)
{
    var checkbox = GetControl(null, "chkFeeAgreement", 6);
    
    if (checkbox != null)
    {
        return args.IsValid = checkbox.checked;
    }
    return args.IsValid = true;
}

function ValidateTuitionAgreement(val, args)
{
    var checkbox = GetControl(null, "chkTuitionAgreement", 6);
    
    if (checkbox != null)
    {
        return args.IsValid = checkbox.checked;
    }
    return args.IsValid = true;
}

function ValidatePersonalCertificationLicensureResponsibilityAcknowledgement(val, args)
{
    var checkbox = GetControl(null, "chkPersonalCertificationLicensureResponsibilityAcknowledgement", 4);
    
    if (checkbox != null)
    {
        return args.IsValid = checkbox.checked;
    }
    return args.IsValid = true;
}

function ValidateExpirationDate(val, args)
{
    return args.IsValid = true;
}


function TogglePhoneEmail()
{
    var showExclamationMarksIn = showExclamationMarks;
    
    for (var i = 0;; i+=2)
    {
        var PhoneEmail = GetControl(null, "Type", 4, null, "References", i);

        if (PhoneEmail == null)
            break;   
           
        var sel = PhoneEmail.rows[0].cells[0].childNodes[0].checked;

        var RegexPhone = GetControl(null, "revProfessionalReferencesPhone", 4,null,"References",i);
        var RegexEmail = GetControl(null, "revProfessionalReferencesEmail", 4,null,"References",i);
                
        if (!sel)
        {
            showExclamationMarks = true;
            EnableValidator(RegexPhone,false);
            EnableValidator(RegexEmail,true);
        }
        else
        {
            showExclamationMarks = true;
            EnableValidator(RegexPhone,true);
            EnableValidator(RegexEmail,false);
        }
    }  
    
    showExclamationMarks = showExclamationMarksIn;
}


function getCheckedValue(radioObj) 
{
	if(!radioObj)
		return "";
	var radioLength = radioObj.length;
	if(radioLength == undefined)
		if(radioObj.checked)
			return radioObj.value;
		else
			return "";
	for(var i = 0; i < radioLength; i++) {
		if(radioObj[i].checked) {
			return radioObj[i].value;
		}
	}
	return "";
}

function Test(control)
{
    var i;
    i = 0;
    alert(control.id);
}

function EnableValidator(val, enable) 
{
    val.enabled = (enable != false);
    if (showExclamationMarks)
    {
        ValidatorValidate(val);
        ValidatorUpdateIsValid();
    }
}

function ValidateDOB(val,args)
{
    var control = GetControl(null, "txtDOB", 2);
    var GetDate = new Date();
    var intYear = GetDate.getFullYear();
    var intYearEntered = Right(control.value,4);

    if (intYearEntered.length > 3 && !isNaN(parseInt(intYearEntered)))
    {
	
        if (intYear <= intYearEntered)
           return args.IsValid = false;
        else
           return args.IsValid = true;
    }	
}

function Left(str, n)
{
	if (n <= 0)
	    return "";
	else if (n > String(str).length)
	    return str;
	else
	    return String(str).substring(0,n);
}

function Right(str, n)
{
    if (n <= 0)
       return "";
    else if (n > String(str).length)
       return str;
    else {
       var iLen = String(str).length;
       return String(str).substring(iLen, iLen - n);
    }
}

function SetTimer()
{
    setTimeout("WarnSessionExp()",intExpiration);
}

function WarnSessionExp()
{
    if (confirm("There has been no activity for some time.\nClick 'OK' if you wish to continue your session,\nor click 'Cancel' to log out.\nFor your security if you are unable to respond to this message\nwithin 2 minutes you will be logged out automatically."))
    {
        //post the page to itself
        document.location.href = "Application.aspx";
    }
    else
    {
        document.location.href = "Default.aspx";
    }
}



if (typeof(Sys) !== 'undefined') Sys.Application.notifyScriptLoaded();

