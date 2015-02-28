// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function liveHook() {

    $("#scroll > span").click(function(e) {

        
        $('html, body').animate({
            scrollTop: $("#scrollToSignup").offset().top
        }, 1000);
        return false;
    });

    //http://trentrichardson.com/examples/timepicker/
    $('input[data-datepicker]').livequery(function () {
        //$(this).datepicker({
        //	changeYear: true,
        //	dateFormat: 'yy-mm-dd',
        //	changeMonth: true
        //});
        $(this).datetimepicker({
            dateFormat:'M d y',
            timeFormat:'h:mmtt',
            hourGrid:4,
            minuteGrid:10,
            hourMin:8,
            hourMax:21,
            ampm:true,
            separator:"  ",
            //	minDate: new Date(2010, 11, 20, 8, 30),
            //	maxDate: new Date(2010, 11, 31, 17, 30)
        });
        //$(this).datetimepicker('setDate', (new Date()));
        var datetime = $(this).attr("data-datepicker");
        if ($.trim(datetime).length) {
            $(this).datetimepicker('setDate', (new Date(datetime)))
        }
        // ui.datepicker
        //$('#example7').datetimepicker({
        //hour: 13,
        //minute: 15
        //});
    });
    $('button[data-button], input[data-button]').livequery(function () {
        $(this).button({
            text:false
        });
    });
    $(".pagination").find("a").livequery(function () {
        $(this).attr("data-remote", true);
    });
    //http://stackoverflow.com/questions/5406837/dynamic-select-using-rails-3-and-jquery/6387145#6387145
    $('select[data-observe-url]').livequery('change', function () {
        // make a POST call and replace the content
        var selected = $(this).find(':selected').val();
        var url = $(this).attr('data-observe-url').replace('%(selected)', selected);
        if ($.trim(selected).length) {
            $.get(url)
        }
        ; // only call on non-blank selection...
        return false;
    });
    // http://stackoverflow.com/questions/2127529/rails-observe-field-using-jquery
    // make it frequency sensitive, see https://github.com/splendeo/jquery.observe_field
    $("input[data-autosubmit]").livequery("keyup", function () {
        var form = $(this).parents("form"); // grab the form wrapping the search bar.
        var url = form.attr("action"); // grab the URL from the form's action value.
        var formData = form.serialize(); // grab the data in the form
        $.get(url, formData);
        return false;
    });
    $("input[data-click-autosubmit]").livequery("change", function () {
        var form = $(this).parents("form"); // grab the form wrapping the search bar.
        var url = form.attr("action"); // grab the URL from the form's action value.
        var formData = form.serialize(); // grab the data in the form
        $.post(url, formData);
        return false;
    });
    // this is to aid dynamic forms
    $('select[data-select-target]').livequery('change', function () {
        var selected = $(this).find(':selected').val();
        var target = $(this).attr('data-select-target') || '';
        var show = $(this).attr('data-select-show');
        var hide = $(this).attr('data-select-hide');
        var clear = $(this).attr('data-select-clear');
        var write = $(this).attr('data-select-write');
        if (selected == target) {
            if (show) {
                $(show).show();
            }
            ;
            if (hide) {
                $(hide).hide();
            }
            ;
            if (clear) {
                $(clear).val('');
            }
            if (write) {
                $(write).val('true');
            }
        } else {
            if (show) {
                $(show).hide();
            }
            ;
            if (hide) {
                $(hide).show();
            }
            ;
            if (write) {
                $(write).val('');
            }
            ;
        }
        return false;
    });

    $(".accordion").livequery(function () {
        $(this).accordion({
            //header: '.head',
            //navigation: true,
            //event: 'mouseover',
            //fillSpace: true,
            //animated: 'easeslide',
            active:false,
            collapsible:true,
            autoHeight:false
        });
    });
    $(".accordion_asset").livequery(function () {
        $(this).accordion({
           active:1,
           collapsible:true,
           autoHeight:false
       });
    });
    //$(".multi-column-list ol").easyListSplitter({
    //		colNumber: 4,
    //		direction: 'vertical'
    //
    //});
    //$(".multi-column-list ol").livequery(function(){
    //$(this).easyListSplitter({
    //colNumber: 4,
    //direction: 'vertical'
    //});
//	});
    $(".multi-column-list-h ol").livequery(function () {
        $(this).easyListSplitter({
            colNumber:4,
            direction:'horizontal'
        });
    });
    //$('ul.jMenu').livequery(function(){
    //	$(this).jMenu();
    //});
    //$('ul.jMenu').jMenu();
    $('.blink').livequery(function () {
        $(this).effect("pulsate", { times:5 }, 1000);
    });
    $('.focus').livequery(function () {
        $(this).focus();
    });
}

;

$(document).ready(function () {
    //http://www.myjqueryplugins.com/jMenu
    //this hook cannot be called more than once on a node to function correctly
    //also internally it assumes #jMenu id, very bad style...
    liveHook();
    $("#spinner").ajaxStart(function () {
        $(this).fadeIn(2000);
    });
    $("#spinner").ajaxStop(function () {
        $(this).hide();
    });
});

