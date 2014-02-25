// JavaScript Document

/* This script and many more are available free online at
The JavaScript Source :: http://javascript.internet.com
Created by: Mike Hudson :: http://www.afrozeus.com */

function setupFadeLinks() {
  arrFadeLinks[0] = "";
  arrFadeTitles[0] = "Certified Trainers";
  arrFadeLinks[1] = "";
  arrFadeTitles[1] = "10+ Experience";
  arrFadeLinks[2] = "";
  arrFadeTitles[2] = "Lifetime Retakes";
  arrFadeLinks[3] = "";
  arrFadeTitles[3] = "75% off all future upgrades";
  arrFadeLinks[4] = "";
  arrFadeTitles[4] = "Micro Classes, 3-6 people";
  arrFadeLinks[5] = "";
  arrFadeTitles[5] = "Lifetime Forum Support";
  arrFadeLinks[6] = "";
  arrFadeTitles[6] = "After Class Video Training";
  arrFadeLinks[7] = "";
  arrFadeTitles[7] = "Top Notch Feedback";
  arrFadeLinks[8] = "";
  arrFadeTitles[8] = "Top Notch Clients";
  arrFadeLinks[9] = "";
  arrFadeTitles[9] = "Shortcut, Efficiency Driven";
  arrFadeLinks[10] = "";
  arrFadeTitles[10] = "Classes don’t get cancelled";
  arrFadeLinks[11] = "";
  arrFadeTitles[11] = "Free Coffee, Tea, Water, Chocolate";
  arrFadeLinks[12] = "";
  arrFadeTitles[12] = "Comfortable, Convenient Location";
  arrFadeLinks[13] = "";
  arrFadeTitles[13] = "Materials Constantly updated";
}

// You can also play with these variables to control fade speed, fade color, and how fast the colors jump.

var m_FadeOut = 255;
var m_FadeIn=0;
var m_Fade = 0;
var m_FadeStep = 3;
var m_FadeWait = 1600;
var m_bFadeOut = true;

var m_iFadeInterval;

window.onload = Fadewl;

var arrFadeLinks;
var arrFadeTitles;
var arrFadeCursor = 0;
var arrFadeMax;

function Fadewl() {
  m_iFadeInterval = setInterval(fade_ontimer, 10);
  arrFadeLinks = new Array();
  arrFadeTitles = new Array();
  setupFadeLinks();
  arrFadeMax = arrFadeLinks.length-1;
  setFadeLink();
}

function setFadeLink() {
  var ilink = document.getElementById("fade_link");
  ilink.innerHTML = arrFadeTitles[arrFadeCursor];
  ilink.href = arrFadeLinks[arrFadeCursor];
}

function fade_ontimer() {
  if (m_bFadeOut) {
    m_Fade+=m_FadeStep;
    if (m_Fade>m_FadeOut) {
      arrFadeCursor++;
      if (arrFadeCursor>arrFadeMax)
        arrFadeCursor=0;
      setFadeLink();
      m_bFadeOut = false;
    }
  } else {
    m_Fade-=m_FadeStep;
    if (m_Fade<m_FadeIn) {
      clearInterval(m_iFadeInterval);
      setTimeout(Faderesume, m_FadeWait);
      m_bFadeOut=true;
    }
  }
  var ilink = document.getElementById("fade_link");
  if ((m_Fade<m_FadeOut)&&(m_Fade>m_FadeIn))
    ilink.style.color = "#" + ToHex(m_Fade);
}

function Faderesume() {
  m_iFadeInterval = setInterval(fade_ontimer, 10);
}

function ToHex(strValue) {
  try {
    var result= (parseInt(strValue).toString(16));

    while (result.length !=2)
            result= ("0" +result);
    result = result + result + result;
    return result.toUpperCase();
  }
  catch(e)
  {
  }
}