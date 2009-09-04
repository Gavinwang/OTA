//login submit
function submitLogin() {
    document.loginForm.submit();
}

//profile submit
function submitProfile() {
    var loginEmail = document.getElementById("loginEmail")
    var loginEmailConfirmation = document.getElementById("loginEmailConfirmation")
    var password = document.getElementById("password")
    var verifyPassword = document.getElementById("verifyPassword")

    var hasError = false;

    document.getElementById("spanle").style.display = "none";
    document.getElementById("spanle1").style.display = "none";
    document.getElementById("spanec").style.display = "none";
    document.getElementById("spanp").style.display = "none";
    document.getElementById("spanp1").style.display = "none";
    document.getElementById("spanvp").style.display = "none";
    document.getElementById("spanst").style.display = "none";
    document.getElementById("spanea").style.display = "none";
    document.getElementById("vmessage").style.display = "none";

    if (loginEmail.value == "") {
        hasError = true;
        document.getElementById("spanle").style.display = "";
    }
    if (loginEmailConfirmation.value == "") {
        hasError = true;
        document.getElementById("spanec").style.display = "";
    }
    if (password.value == "") {
        hasError = true;
        document.getElementById("spanp").style.display = "";
    }
    if (verifyPassword.value == "") {
        hasError = true;
        document.getElementById("spanvp").style.display = "";
    }
    if (loginEmail.value != loginEmailConfirmation.value) {
        hasError = true;
        document.getElementById("spanle").style.display = "";
        document.getElementById("spanec").style.display = "";
        document.getElementById("emailError").innerHTML = "* Email addresses do not match.";
        document.getElementById("emailError").style.display = "";
    } else {
        document.getElementById("emailError").style.display = "none";
    }
    if (password.value != verifyPassword.value) {
        hasError = true;
        document.getElementById("spanp").style.display = "";
        document.getElementById("spanvp").style.display = "";
        document.getElementById("passwordError").style.display = "";
        document.getElementById("passwordError").innerHTML = "* Password do not match.";
    } else {
        document.getElementById("passwordError").style.display = "none";
        var patrn = /^[a-zA-Z0-9]{6,20}$/;
        if (!patrn.exec(password.value)) {
            hasError = true;
            document.getElementById("spanp").style.display = "";
        }
    }

    if (!document.getElementById("dom").checked && !document.getElementById("int").checked) {
        hasError = true;
        document.getElementById("spanst").style.display = "";
    }
    if (!document.getElementById("emailAgreement").checked) {
        hasError = true;
        document.getElementById("spanea").style.display = "";
    }
    if (!hasError) {
        document.profileForm.submit();
    } else {
        document.getElementById("error").style.display = "";
        document.getElementById("error").innerHTML = "* Some <i>required information</i> is missing or incomplete. Please check your entries and try again.";
    }
}

// degree submit
function submitDegree() {
    document.degreeForm.submit();
}

//welcome submit
function submitWelcome() {
    document.welcomeForm.submit();
}

//welcome page
function showhidewel(temp) {
    if (temp == 1) {
        var pos = Position.cumulativeOffset($("divwel"));
        $("searchCourse").style.display = "block";
        $("searchCourse").style.left = (pos[0] - 90) + "px";
        $("searchCourse").style.top = (pos[1] - 10) + "px";
    } else {
        $("searchCourse").style.display = "none";
    }
}

//personal checkbox
function copyMail() {
    var mstreet = document.getElementById("mstreet");
    var mcity = document.getElementById("mcity");
    var mstate = document.getElementById("mstate");
    var mzip = document.getElementById("mzip");
    var mcountry = document.getElementById("mcountry");
    var pcountry = document.getElementById("pcountry");
    var pstreet = document.getElementById("pstreet");
    var pcity = document.getElementById("pcity");
    var pstate = document.getElementById("pstate");
    var pzip = document.getElementById("pzip");
    if (document.getElementById("sameMail").checked) {
        pstreet.value = mstreet.value;
        pcity.value = mcity.value;
        pstate.value = mstate.value;
        pzip.value = mzip.value;
        pcountry.value = mcountry.value;
    } else {
        pstreet.value = "";
        pcity.value = "";
        pstate.value = "";
        pzip.value = "";
        pcountry.value = "";
    }

}

//personal if a us
function changeCC() {
    var us = document.getElementById("us");
    var other = document.getElementById("other");
    if (us.checked) {
        document.getElementById("bodyCC").style.display = "none";
    } else if (other.checked) {
        document.getElementById("bodyCC").style.display = "";
    }
}
//personal  dom check ...
function checkCardNum() {
    var pat2 = /(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))/;
    var pat3 = /^\d*$/;
    var warning = true;
    var obj1 = document.getElementById("r_alien_yes");
    var obj2 = document.getElementById("us_resident_alien");
    var obj3 = document.getElementById("card_number");
    var hint_2 = document.getElementById("hint_2");
    var hint_3 = document.getElementById("hint_3");
    if (obj1 != null) {
        if (obj1.checked == true) {
            if (!pat2.exec(obj2.value)) {
                hint_2.innerHTML = "!";
                warning = false;
            } else {
                hint_2.innerHTML = "";
            }
            if (obj3.value != "") {
                if (!pat3.exec(obj3.value)) {
                    hint_3.innerHTML = "!";
                    warning = false;
                } else {
                    hint_3.innerHTML = "";
                }
            } else {
                hint_3.innerHTML = "!";
                warning = false;
            }
        }
    }
    return warning;
}


//personal submit
function submitPersonal() {
    //if (!checkPhone()) {
    //    $("hint_phone_num").style.display = "";
    //    if ($("cw") != null) {
    //        $("hint_phone_num").style.display = "none";
    //    }
    //    return;
    //}

    if (!checkCardNum()) {
        if ($("cw") != null) {
            $("hint_phone_num").style.display = "none";
        }
        return;
    }
    document.personalForm.submit();
}
//personal social_security_number
function checkSocial() {
    var patrn = /^\d{3}[-]\d{2}[-]\d{4}$/;
    var social = document.getElementById("social_security_number");
    var hint_social = document.getElementById("hint_social");
    if (social != null) {
        if (social == "" || !patrn.exec(social.value)) {
            hint_social.innerHTML = "!";
            return false;
        }
    }
    return true;
}
//personal checkPhone
function checkPhone() {
    var home = document.getElementById("home");
    var mobile = document.getElementById("mobile");
    var work = document.getElementById("work");
    var least = document.getElementById("least");

    var hint_home = document.getElementById("hint_home");
    var hint_mobile = document.getElementById("hint_mobile");
    var hint_work = document.getElementById("hint_work");
    var check = document.getElementById("check");

    var r_home = document.getElementById("r_home");
    var r_mobile = document.getElementById("r_mobile");
    var r_work = document.getElementById("r_work");

    var hint_phone_num = document.getElementById("hint_phone_num");
    var error = false
    if (r_home.checked == true && home.value == "") {
        hint_phone_num.style.display = "";
        hint_home.style.display = "";
        home.focus();
        error = true;
    } else {
        hint_home.style.display = "none";
    }
    if (r_mobile.checked == true && mobile.value == "") {
        hint_phone_num.style.display = "";
        hint_mobile.style.display = "";
        mobile.focus();
        error = true;
    } else {
        hint_mobile.style.display = "none";
    }
    if (r_work.checked == true && work.value == "") {
        hint_phone_num.style.display = "";
        hint_work.style.display = "";
        work.focus();
        error = true;
    } else {
        hint_work.style.display = "none";
    }

    if (error) {
        return false;
    }

    return true;
}

//leftbar changePassword div show or hedden
function showChangePassword() {
    $("spanChangeP").style.display = "none";
    if (document.getElementById("newPassword").style.display == "") {
        document.getElementById("newPassword").style.display = "none";
    } else {
        document.getElementById("newPassword").style.display = "";
    }
}

// leftbar submit new password
function submitNewPassword() {
    $("spanChangeP").style.display = "none";
    if ($("flash") != null) {
        $("flash").style.display = "none";
    }
    var patrn = /^[a-zA-Z0-9]{6,20}$/;
    if (!patrn.exec($("changePassword").value)) {
        document.getElementById("spanChangeP").style.display = "";
        return;
    }
    document.changePasswordForm.submit();
}

//academic page date format validate
function checkFormat() {
    var patrn = /^((([0]?[1-9]{1})|([1-9]{1})|([1]{1}[0-2]{1}))(\/){1}[0-9]{4})$/  ;


    var as_1 = document.getElementById("academic_1[attend_date_start]");
    var ae_1 = document.getElementById("academic_1[attend_date_end]");
    var hint_1 = document.getElementById("hint_1");

    if (as_1.value != "" || ae_1.value != "") {
        if (!patrn.exec(as_1.value) || !patrn.exec(ae_1.value)) {
            hint_1.innerHTML = "!";
            return false;
        } else {
            hint_1.innerHTML = "";
        }
    }

    var another_1 = document.getElementById("another_1");
    if (another_1.style.display == "block") {
        var as_2 = document.getElementById("academic_2[attend_date_start]");
        var ae_2 = document.getElementById("academic_2[attend_date_end]");
        var hint_2 = document.getElementById("hint_2");
        if (as_2.value != "" || ae_2.value != "") {
            if (!patrn.exec(as_2.value) || !patrn.exec(ae_2.value)) {
                hint_2.innerHTML = "!";
                return false;
            } else {
                hint_2.innerHTML = "";
            }
        }
    }

    var another_2 = document.getElementById("another_2");
    if (another_2.style.display == "block") {
        var as_3 = document.getElementById("academic_3[attend_date_start]");
        var ae_3 = document.getElementById("academic_3[attend_date_end]");
        var hint_3 = document.getElementById("hint_3");
        if (as_3.value != "" || ae_3.value != "") {
            if (!patrn.exec(as_3.value) || !patrn.exec(ae_3.value)) {
                hint_3.innerHTML = "!";
                return false;
            } else {
                hint_3.innerHTML = "";
            }
        }
    }
    return true;
}
//academic page
function checkTrans() {
    var patrn1 = /(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))/;
    var obj1 = document.getElementById("complete_bottom");
    var obj2 = document.getElementById("date");
    var obj3 = document.getElementById("signature");
    var hint = document.getElementById("hint");
    var hint_signature = document.getElementById("hint_signature");
    var error = false;
    if (obj1.checked) {
        if (!patrn1.exec(obj2.value)) {
            hint.innerHTML = "!";
            error = true;
        } else {
            hint.innerHTML = "";
        }
        if (obj3.value == "") {
            hint_signature.innerHTML = "!";
            error = true;
        } else {
            hint_signature.innerHTML = "";
        }
    }
    if (error) {
        return false;
    }
    return true;
}


//academic page submit
function academicSubmit() {
    if (!checkFormat()) {
        return;
    }
    if ($("complete_bottom") != null && $("complete_bottom1") != null) {
        if (!$("complete_bottom").checked && !$("complete_bottom1").checked) {
            $("spanTranript").style.display = "";
            return;
        }
        if (!checkTrans()) {
            return;
        }
    }

    document.academicForm.submit();
}
//academic page Add Another College/University/Institution display  none or block
//function display(temp, hi) {
//    var obj = document.getElementById(temp);
//    var hi = document.getElementById(hi);
//    obj.style.display == "none" ? obj.style.display = "block" : obj.style.display = "none";
//    obj.style.display == "none" ? hi.value = false : hi.value = true;
//
//}
//academic page Transcript release  display  none or block
function selectTR(obj) {
    var trdiv = document.getElementById("trdiv");
    obj.value != "0" ? trdiv.style.display = "" : trdiv.style.display = "none";
}

//authorization page date form validate
function checkAuthorizationFormat() {
    var patrn = /(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))/;
    var obj3 = document.getElementById("signature");
    var hint_signature = document.getElementById("hint_signature");
    var obj2 = document.getElementById("date");
    var hint = document.getElementById("hint");
    var error = false;
    if (!patrn.exec(obj2.value)) {
        hint.innerHTML = "!";
        error = true;
    } else {
        hint.innerHTML = "";
    }
    if (obj3.value == "") {
        hint_signature.innerHTML = "!";
        error = true;
    } else {
        hint_signature.innerHTML = "";
    }
    if (error) {
        return false;
    }
    return true;
}
//authorization page submit hint
function showhideview(temp) {

    if (!checkAuthorizationFormat()) {
        return;
    }
    if (temp == 1) {
        var pos = Position.cumulativeOffset($("view"));
        $("searchCourse").style.display = "block";
        $("searchCourse").style.left = (pos[0] - 220) + "px";
        $("searchCourse").style.top = (pos[1] - 60) + "px";
    } else {
        $("searchCourse").style.display = "none";
    }
}
//authorization page Submit
function authorizationSubmit()
{
    if (!checkAuthorizationFormat()) {
        return;
    }
    document.authorizationForm.submit();
    //var obj1 = document.getElementById("date");
    //var obj2 = document.getElementById("signature");
    //location.href = "/authorization/save?date=" + obj1.value + "&signature=" + obj2.value;
}

//careerinfo page submit
function careerinfoSubmit() {
    if (!checkSem()) {
        if ($("cw") != null) {
            $("hint_phone_num").style.display = "none";
        }
        return;
    }
    document.employmentForm.submit();
}
//careerinfo page Have you previously applied for graduate admission at Concordia University-Portland display block or none
function checkThis(a) {
    var obj = document.getElementById("semester");
    a.value == "0" ? obj.style.display = "" : obj.style.display = "none";
}
//careerinfo page
function checkSem() {
    var pat2 = /^\d*$/;
    var warning = true;
    var obj1 = document.getElementById("state2");
    var obj2 = document.getElementById("semester2");
    var obj3 = document.getElementById("year");
    var hint_2 = document.getElementById("hint_2");
    var hint_3 = document.getElementById("hint_3");
    var error = false;
    if (obj1.checked == true) {
        if (obj3.value == "") {
            hint_3.innerHTML = "!";
            error = true;
        } else {
            if (!pat2.exec(obj3.value)) {
                hint_3.innerHTML = "!";
                error = true;
            } else {
                hint_3.innerHTML = "";
            }
        }
        if (obj2.value == "") {
            hint_2.innerHTML = "!";
            error = true;
        } else {
            hint_2.innerHTML = "";
        }
    }
    if (error) {
        document.getElementById("hint_phone_num").style.display = "";
        return false;
    }
    return true;
}
//review page submit
function reviewSubmit() {
    document.reviewForm.submit();
}

//leftbar  page Change Program display
function changeProgramDisplay() {
    var obj = document.getElementById("changeProgram");
    obj.style.display == "none" ? obj.style.display = "block" : obj.style.display = "none";
}
//leftbar  page Change Program or Start Date submit
function changeProgramFormSubmit() {
    document.changeProgramForm.submit();
}

//forgetpwd  page submit
function pwdFormSubmit() {
    document.pwdForm.submit();
}