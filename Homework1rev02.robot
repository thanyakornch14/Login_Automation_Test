*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${url}                            https://automate-test.stpb-digital.com/login/
${browser}                        chrome
${locator_email}                  id=email
${locator_password}               name=password
${locator_btnlogin}               css=#btn-login
${locator_msg_email}              css=#__next > div.layout-wrapper.MuiBox-root.css-33gw4 > div > div > div.MuiBox-root.css-15tnlg1 > div > div > form > div.MuiFormControl-root.MuiFormControl-fullWidth.css-m5bgtg > p
${locator_msg_password}           css=#__next > div.layout-wrapper.MuiBox-root.css-33gw4 > div > div > div.MuiBox-root.css-15tnlg1 > div > div > form > div.MuiFormControl-root.MuiFormControl-fullWidth.css-tzsjye > p
${locator_link_createaccount}     css=#__next > div.layout-wrapper.MuiBox-root.css-33gw4 > div > div > div.MuiBox-root.css-15tnlg1 > div > div > form > div.MuiBox-root.css-z0xj7h > p.MuiTypography-root.MuiTypography-body1.css-azsy9a > a
${locator_signup}                 css=#btn-sign-up


*** Keywords ***
Open Web Kru P'Beam
    Open Browser    ${url}    ${browser}
    Maximize Browser Window

Input Email Pass
    Wait Until Element Is Visible     id=email    
    Input Text    ${locator_email}    Beam1234@gmail.com

Input Email Fail1
    Wait Until Element Is Visible        id=email
    Input Text       ${locator_email}    Beam1234gmail.com
    Click Element    ${locator_password}

Input Email Fail2
    Wait Until Element Is Visible        id=email
    Input Text       ${locator_email}    ไทย
    Click Element    ${locator_password}

Input Email Fail3
    Wait Until Element Is Visible    id=email
    Input Text       ${locator_email}    09912345678
    Click Element    ${locator_password}

Input Password Pass
    Wait Until Element Is Visible        id=email
    Input Text    ${locator_password}    1234567890

Input Password Fail1
    Wait Until Element Is Visible           id=email
    Input Text       ${locator_password}    123
    Click Element    ${locator_email}

Input Password Fail2
    Wait Until Element Is Visible           id=email
    Input Text       ${locator_password}    beam
    Click Element    ${locator_email}

Login Pass with registered account
    Wait Until Element Is Visible           id=email
    Input Text       ${locator_email}       user.test@krupbeam.com
    Input Text       ${locator_password}    123456789
    Click Element    ${locator_btnlogin}

Login Fail with non-registered account
    Wait Until Element Is Visible           id=email
    Input Text       ${locator_email}       Beam12345678@gmail.com
    Input Text       ${locator_password}    12345678900
    Click Element    ${locator_btnlogin}

Login without data
    Wait Until Element Is Visible           id=email
    Input Text       ${locator_email}       ${EMPTY}
    Input Text       ${locator_password}    ${EMPTY}
    Click Element    ${locator_btnlogin}

Check Hyperlink Create Account
    Click Element    ${locator_linkcreateaccount}

Msg Email
    Wait Until Element Contains    ${locator_msg_email}       email must be a valid email

Msg Password
    Wait Until Element Contains    ${locator_msg_password}    password must be at least 5 characters
    

*** Test Cases ***
TC000 Check Name Page
    Open Web Kru P'Beam
    Wait Until Page Contains    Kru P' Beam
    Close Browser

TC001 Check input format email
    Open Web Kru P'Beam
    Input Email Pass
    Wait Until Page Does Not Contain    email is a required field
    Close Browser

TC002 Check input non-format email
    Open Web Kru P'Beam
    Input Email Fail1
    Msg Email
    Reload Page
    Input Email Fail2
    Msg Email
    Reload Page
    Input Email Fail3
    Msg Email
    Close Browser

TC003 Check input password more 5 digit
    Open Web Kru P'Beam
    Input Password Pass
    Wait Until Page Does Not Contain    password must be at least 5 characters
    Close Browser

TC004 Check input password less than 5 digit
    Open Web Kru P'Beam
    Input Password Fail1
    Msg Password
    Reload Page
    Input Password Fail2
    Msg Password
    Close Browser

TC005 Check Login with regitered data
    Open Web Kru P'Beam
    Login Pass with registered account
    Wait Until Page Contains    Search Filters
    Close Browser

TC006 Check Login with non-registered data
    Open Web Kru P'Beam
    Login Fail with non-registered account
    ${msg_email}=    Get Text     ${locator_msg_email}
    Should Be Equal As Strings    ${msg_email}    Email or Password is invalid
    Close Browser

TC007 Check Login without Data
    Open Web Kru P'Beam
    Login without data
    ${msg_email}=      Get Text   ${locator_msg_email}
    ${msg_password}=   Get Text   ${locator_msg_password}
    Should Be Equal As Strings    ${msg_email}      email is a required field
    Should Be Equal As Strings    ${msg_password}   password must be at least 5 characters
    Close Browser

TC008 Check Hyperlink create an account
    Set Selenium Speed    0.5s
    Open Web Kru P'Beam
    Check Hyperlink Create Account
    Wait Until Element Is Visible    ${locator_signup}
    Close Browser