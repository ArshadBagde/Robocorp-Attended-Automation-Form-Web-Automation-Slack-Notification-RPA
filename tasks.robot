*** Settings ***
Documentation     Form+Web Automation+Slack.
Library           RPA.Notifier
Library           RPA.Browser
Library           RPA.Dialogs
Library           Collections

*** Variables ***
${channel}=       general
${webhook_url}=    https://hooks.slack.com/services/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

*** Keywords ***
user input to Form
    Create Form    Fill User Details
    Add Text Input    label=Enter FirstName    name=firstName    value=""
    Add Text Input    label=Enter LastName    name=lastName    value=""
    Add radio buttons    element_id=gender    options=Male,Female    default=Male
    Add checkbox    label=Favourite Chai    element_id=tea    option=Black Tea, Red Tea,Oolong Tea
    Add Dropdown    label=Select Country    element_id=country    options=USA,Europe,Asia,Australia
    ${response}=    Request Response
    [Return]    ${respose}

send message to slack
    ${result}=    Notify Slack
    ...    message=Good Afternoon
    ...    channel=${channel}
    ...    webhook_url=${webhook_url}
    LOG    ${result}
    Should Be True    ${result}

fill form on website
    &{form response}=    user input to form
    LOG    ${form_response}
    Open Available Browser    http://www.practiceselenium.com/practice-form.html
    Maximize Browser Window
    Set Selenium Speed    1
    Input Text    //input[@name='firstname']    ${form_response.firstName}
    Input Text    //input[@name='lastName']    ${form_response.lastName}
    Select Radio Button    group_name=sex    value=${form_response.gender}
    @{list}=    Get Dictionary Keys    ${form_response}
    LOG    ${lst}
    FOR    ${key}    IN    @{lst}
        Log    ${key}
        IF    "${key}"=="tea1"
            LOG    tea1
            Select Checkbox    //input[@id='tea1']
        ELSE IF    "${key}"=="tea2"
            LOG    tea2
            Select Checkbox    //input[@id='tea2']
        ELSE IF    "${key}"=="tea3"
            LOG    tea3
            Select Checkbox    //input[@id='tea3']
        END
    END
    Select From List By Label    //select[@id='continenets']    ${form_response.country}
    Select From List By Label    //selesct[@id='selenium_commands']    Browser Commands
    Select From List By Label    //selest[@id='selenium_commands']    Wait Commands
    Sleep    2
    Click Button    //button[normalize-space()='OK']
    Sleep    1
    Close Browser

*** Tasks ***
Minimal task
    Log    Done.
