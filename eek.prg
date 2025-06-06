program EEEEKEEEEEKHOOOOOOK;

import "libmod_gfx";
import "libmod_misc";
import "libmod_sound";
import "libmod_input";
import "libmod_debug";

#include "jkeys.lib"

const
    gm = 0;
    unlck = 0;

    clim = 4;
    resx = 320;
    resy = 240;
    pie = 0;
    salto = 1;
    walking = 2;
    walljump = 3;
    dano = 4;
    tplat = 120;
    tplatd = 120;
    margenx = 90;
    margenxw = 60;
    wlkspd = 4;
    parao = 0;
    hoook = 1;
    mirar = 2;
    ater = 3;
    miraiz = 4;
    mirader = 5;
    parpa = 6;
    mirarr = 7;
    uhuh = 8;
    muerto = 9;
    abajo = 1;
    arriba = 0;
    tinvul = 200;

    DEFAULT_FPS = 60;

local
    byte est, subest;

#define write_string(font_id,x,y,alignment,pointer_to_data) WRITE_VALUE(font_id,x,y,alignment,text_string,pointer_to_data)
#define write_int(font_id,x,y,alignment,pointer_to_data) WRITE_VALUE(font_id,x,y,alignment,text_int,pointer_to_data)

#define init_bgd1_background_emulation() background.file = 0; background.graph = map_new(320,240)
#define put_screen(f,g) map_clear(0, background.graph ); map_put(0, background.graph, f, g, 160, 120)
#define clear_screen() map_clear(0, background.graph )
#define put(f,g,x,y) map_put(0, background.graph, f, g, x, y)
#define xput(f,g,x,y,angle,size,flags,region) map_put(0, background.graph, f, g, x, y, angle, size, size, flags, 255, 255, 255, 255)
#define map_xput(fdst,gdst,gsrc,x,y,angle,size,flags) map_put(fdst, gdst, fdst, gsrc, x, y, angle, size, size, flags, 255, 255, 255, 255)

global
    int p0, p1, p2, p3, p4, p5, p6, p7, p8, p9;
    int admis = 3;
    int angmis = 2500;
    int sx, sy;
    byte ener;
    byte pausa;
    byte faseactual;
    byte finfase;
    byte perfect;
    int stageid;
    struct conf
        byte grav;
        byte fase[ 9 ];
        byte vidafase[ 9 ];
        int modal;
        int m2x;
        int vsync;
        byte color;
        float aspect;
        byte fullsc;
        byte autocam = 0;
        byte gameclear;
        int reesc = 06400480;
    end
    //dfcol;
    int vidas = 3;
    int gfpg;
    int level;
    int tutofpg;
    int levelm;
    int monofpg;
    int rayofpg;
    int platfpg;
    int misfpg;
    int explofpg;
    int intro_fpg;
    int enem;
    int voz;
    int chan;
    int pare;
    int techo;
    int pincha;
    int salida;
    int prota;
    byte left, right, down, select;
    byte invul;
    double realx, realy;
    double realx2, realy2;
    double modx, mody;
    int boing;
    int ooh;
    int finm;
    int no;
    int ris;
    int alar;
    int cabreowav;
    int cabreowav2;
    int cabreowav3;
    //cabreohw;
    int pll;
    int jaulawav;
    int jaulacwav;
    int pausaw1;
    int pausaw2;
    int shotwav;
    int corkw;
    int drollw;
    int bomw;
    int prrz;
    int cla;
    int aak;
    int aak2;
    int aak3;
    int cabe;
    int techowav;
    int saltowav;
    int saltowav1;
    int canc;
    int color;

function set_video_mode(int w, h)
begin
    if ( conf.fullsc )
        desktop_get_size( &sx, &sy );
        screen.scale_resolution = sx*10000+sy;
    else
        screen.scale_resolution = conf.reesc;
    end
    screen.fullscreen = conf.fullsc;
    screen.scale_resolution_aspectratio = sra_preserve;
    set_mode( resx, resy, ( conf.modal ? MODE_GRAB_INPUT : 0 ) | ( conf.vsync ? MODE_WAITVSYNC : 0 ) );
    desktop_get_size( &sx, &sy );
    int ww, wh;
    window_get_size(&ww, &wh, NULL, NULL, NULL, NULL );
    window_set_pos( sx / 2 - ww / 2, sy / 2 - wh / 2 );
end


private
    int dsx, dsy;
begin
    conf.fase[ 0 ] = 1;
    conf.vidafase[ 0 ] = 3;
    if ( fexists( get_pref_path("bennugd.org","eeeek") + "profile.dat" ))
        load( get_pref_path("bennugd.org","eeeek") + "profile.dat", conf );
    else
        conf.color = 0;
        conf.modal = 1;
    end
    if ( unlck )
        for ( z = 0; z < 9; z++ )
            conf.fase[ z ] = 2;
            conf.vidafase[ z ] = 3;
        end
    end

    sound.channels = 16;
    jkeys_set_default_keys();
    jkeys_controller();

    set_fps( DEFAULT_FPS, 0 );

    set_video_mode( resx, resy );

    window_set_title( "EEEEK! EEEEEK! HOOOOOOK!!!" );

    init_bgd1_background_emulation();

    gfpg = fpg_load( "./data/general.fpg" );
    window_set_icon( gfpg, 24 );
//    monofpg = fpg_load( "./data/hr.fpg" );
    p0 = fpg_load( "./data/hr-norm.fpg" );
    p1 = fpg_load( "./data/hr-ng.fpg" );
    p2 = fpg_load( "./data/hr-nj.fpg" );
    p3 = fpg_load( "./data/hr-b.fpg" );
    p4 = fpg_load( "./data/hr-am.fpg" );
    p5 = fpg_load( "./data/hr-rs.fpg" );
    p6 = fpg_load( "./data/hr-rj.fpg" );
    p7 = fpg_load( "./data/hr-qm.fpg" );
    p8 = fpg_load( "./data/hr-z.fpg" );
    p9 = fpg_load( "./data/hr-pl.fpg" );
    aak = sound_load( "./data/aak3.wav" );
    aak2 = sound_load( "./data/aak2.wav" );
    cabreowav = sound_load( "./data/cabreo.wav" );
    cabreowav2 = sound_load( "./data/cabreo2.wav" );
    cabreowav3 = sound_load( "./data/cabreo3.wav" );
    techowav = sound_load( "./data/techo.wav" );
    saltowav = sound_load( "./data/salto1.wav" );
    saltowav1 = sound_load( "./data/salto2.wav" );
    pausaw1 = sound_load( "./data/pausa1.wav" );
    pausaw2 = sound_load( "./data/pausa2.wav" );
    boing = sound_load( "./data/boing.wav" );
    ooh = sound_load( "./data/ooh.wav" );

    logos();
    repeat
        frame;
    until ( !get_id( type logos ))
    fade_on( 500 );

    prota = menu();
end

process logos()
begin
    file = fpg_load( "./data/logos.fpg" );
    fade_off( 500 );
    paralo( 5000 );
    put_screen( file, 1 );
    fade_on( 500 );
    paralo( 20000 );
    fade_off( 500 );
    paralo( 10000 );
    put_screen( file, 2 );
    fade_on( 500 );
    paralo( 20000 );
    fade_off( 500 );
    paralo( 10000 );
    put_screen( file, 3 );
    fade_on( 500 );
    paralo( 20000 );
    fade_off( 500 );
    paralo( 10000 );
    put_screen( file, 4 );
    sound_play( cabreowav2, 0 );
    fade_on( 500 );
    paralo( 35000 );
    fade_off( 500 );
    paralo( 5000 );
    clear_screen();
    fpg_unload( file );
end


process pupi( est )
begin
    file = father.file;
    frame;
    if ( est == 0 )
        graph = 3;
    else
        graph = 20;
        if ( !get_id( type menmonete ))
            x = 22;
            y = 203;
        end
    end
    repeat
        frame;
    until ( !exists( father ))
end


process bplay()
begin
    file = father.file;
    graph = 7;
    x = 420;
    if ( os_id == OS_GP2X_WIZ )
        y = 140;
    else
        y = 115;
    end
    repeat
        x -= subest / 4;
        subest++;
        if ( x < 235 )
            x = 235;
        end
        frame;
    until ( x == 235 )
    subest = 0;
    repeat
        if ( collision( type mouse ) and mouse.left )
            prota.est = 2;
        end
        frame;
    until ( prota.est != 0 )
    repeat
        y += subest / 4;
        subest++;
        frame;
    until ( y > 270 )
    if ( prota.est == 2 )
        for ( z = 0; z <= 7; z++ )
            bfase( z );
        end
        subest = 0;
        for ( est = 1; est <= 9; est++ )
            if ( conf.fase[ est ]
                == 2 ) subest = 1;
            end
        end
        if ( subest == 1 )
            bcolor();
        end
        subest = 1;
        if ( conf.gameclear or unlck )
            bgrav();
        end
        bback2();
    end
end


process bback2()
begin
    file = prota.file;
    graph = 25;
    x = -61;
    y = 90;
    repeat
        subest++;
        x += subest / 4;
        if ( x > 0 )
            x = 0;
        end
        frame;
    until ( x == 0 )
    subest = 0;
    repeat
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                prota.est = 0;
            end
        end
        frame;
    until ( prota.est != 2 )
    repeat
        subest++;
        x -= subest / 4;
        frame;
    until ( x < -90 )
    if ( prota.est == 0 )
        bplay();
        bquit();
        if ( os_id != OS_GP2X_WIZ )
            boption();
        end
    end
end


process bcolor()
begin
    file = prota.file;
    graph = 23;
    x = 157;
    y = 90;
    alpha = 0;
    subest = conf.color;
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    repeat
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                //prota.est=0;
                loop
                    subest++;
                    if ( subest == 10 )
                        subest = 0;
                    end
                    if ( conf.fase[ subest ] == 2 )
                        conf.color = subest;
                        break;
                    end
                end
                sound_play( techowav, 0 );
                size = 90;
                paralo( 500 );
                size = 100;
            end
        end
        frame;
    until ( prota.est != 2 )
    repeat
        alpha = clamp( alpha-10, 0, 255 );
        frame;
    until ( alpha == 0 )
end


process bgrav()
begin
    file = prota.file;
    x = 97;
    y = 90;
    alpha = 0;
    graph = 24;
    if ( conf.grav == 1 )
        size = 90;
    else
        size = 100;
    end
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    repeat
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                frame;
                if ( conf.grav == 0 )
                    conf.grav = 1;
                else
                    conf.grav = 0;
                end
                sound_play( techowav, 0 );
                size = 90;
                paralo( 500 );
                size = 100;
            end
        end
        if ( conf.grav == 1 )
            size = 90;
        else
            size = 100;
        end
        frame;
    until ( prota.est != 2 )
    repeat
        alpha = clamp( alpha-10, 0, 255 );
        frame;
    until ( alpha == 0 )
end


process bvidas( est, double x, y )
begin
    file = prota.file;
    graph = conf.vidafase[ est ] + 40;
    alpha = 0;
    //x=father.x+18; y=father.x+18;
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    repeat
        frame;
    until ( prota.est != 2 )
    repeat
        alpha = clamp( alpha-10, 0, 255 );
        frame;
    until ( alpha == 0 )
end


process estre()
begin
    frame;
    file = prota.file;
    graph = 22;
    x = father.x + 32;
    y = father.y + 30;
    z = -2;
    repeat
        alpha = father.alpha;
        frame;
    until ( alpha == 0 )
end


process bfase( est )
    private
        byte maxalpha = 255;
begin
    file = prota.file;
    graph = est + 30;
    alpha = 0;
    if ( conf.fase[ est ] == 0 )
        maxalpha = 100;
    end
    switch ( est )
        case 0:
            x = 230;
            y = 50;
        end
        case 1:
            x = 186;
            y = 96;
        end
        case 2:
            x = 230;
            y = 96;
        end
        case 3:
            x = 273;
            y = 96;
        end
        case 4:
            x = 186;
            y = 144;
        end
        case 5:
            x = 230;
            y = 144;
        end
        case 6:
            x = 273;
            y = 144;
        end
        case 7:
            x = 230;
            y = 192;
        end
        case 8:
            x = 230;
            y = 192;
        end
        case 9:
            x = 273;
            y = 192;
        end
    end
    if ( conf.fase[ est ] >= 2 )
        estre();
    end
    repeat
        alpha = clamp( alpha+(maxalpha == 255 ? 10 : 5 ), 0, maxalpha );
        frame;
    until ( alpha == maxalpha )
    if ( alpha == 255 )
        bvidas( est, x + 18, y + 40 );
    end
    repeat
        if ( alpha == 255 )
            if ( collision( type mouse ) and mouse.left )
                repeat
                    frame;
                until ( !mouse.left )
                if ( collision( type mouse ))
                    prota.est = 6;
                    faseactual = est;
                end
            end
        end
        frame;
    until ( prota.est != 2 )
    repeat
        alpha = clamp( alpha-(maxalpha == 255 ? 10 : 5 ), 0, maxalpha );
        frame;
    until ( alpha == 0 )
    if ( prota.est == 6 )
        prota.est = 10;
    end
    frame;
end


process bback()
begin
    file = prota.file;
    graph = 16;
    x = 320;
    y = 218;
    repeat
        subest++;
        x -= subest / 4;
        if ( x < 230 )
            x = 230;
        end
        frame;
    until ( x == 230 )
    subest = 0;
    repeat
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                prota.est = 0;
            end
        end
        frame;
    until ( prota.est != 1 )
    repeat
        subest++;
        x += subest / 4;
        frame;
    until ( x > 320 )
    bplay();
    bquit();
    if ( os_id != OS_GP2X_WIZ )
        boption();
    end
end


process bquit()
begin
    file = father.file;
    graph = 8;
    x = 420;
    if ( os_id == OS_GP2X_WIZ )
        y = 190;
    else
        y = 215;
    end
    repeat
        x -= subest / 4;
        subest++;
        if ( x < 235 )
            x = 235;
        end
        frame;
    until ( x == 235 )
    subest = 0;
    repeat
        if ( collision( type mouse ) and mouse.left )
            save( get_pref_path("bennugd.org","eeeek") + "profile.dat", conf );
            exit();
        end
        frame;
    until ( prota.est != 0 )
    repeat
        y += subest / 4;
        subest++;
        frame;
    until ( y > 270 )
end


process boption()
begin
    file = father.file;
    graph = 6;
    x = 420;
    y = 165;
    repeat
        x -= subest / 4;
        subest++;
        if ( x < 235 )
            x = 235;
        end
        frame;
    until ( x == 235 )
    subest = 0;
    repeat
        if ( collision( type mouse ) and mouse.left )
            prota.est = 1;
        end
        frame;
    until ( prota.est != 0 )
    repeat
        y += subest / 4;
        subest++;
        frame;
    until ( y > 270 )
    repeat
        frame;
    until ( !get_id( type bplay ))
    if ( prota.est == 1 )
        optwin();
    end
end


process optwin()
begin
    file = prota.file;
    graph = 10;
    alpha = 0;
    x = 150;
    y = 134;
    repeat
        alpha = clamp( alpha+5, 0, 255 );
        frame;
    until ( alpha == 255 )
    bmodal();
    bsize();
    bback();
    b2x();
    bsync();
    bfullsc();
    repeat
        frame;
    until ( prota.est != 1 )
    repeat
        alpha = clamp( alpha-5, 0, 255 );
        frame;
    until ( alpha == 0 )
end


process bfullsc()
begin
    file = prota.file;
    x = 0;
    y = 70;
    if ( conf.fullsc == 1 )
        graph = 18;
    else
        graph = 17;
    end
    repeat
        subest++;
        x += subest / 4;
        if ( x > 100 )
            x = 100;
        end
        frame;
    until ( x == 100 )
    subest = 0;
    repeat
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                if ( conf.fullsc == 0 )
                    conf.fullsc = 1;
                    conf.reesc = -1;
                    conf.m2x = 0;
                else
                    conf.reesc = 06400480;
                    conf.fullsc = 0;
                end
                set_video_mode( resx, resy ); //MODE_GRAB_INPUT);
            end
        end
        if ( conf.fullsc == 1 )
            graph = 18;
        else
            graph = 17;
        end
        frame;
    until ( prota.est != 1 )
    repeat
        subest++;
        x -= subest / 4;
        frame;
    until ( x < 0 )
end


process bmodal()
begin
    file = prota.file;
    graph = 11;
    x = 290;
    y = 109;
    z = -10;
    repeat
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                if ( !conf.modal )
                    conf.modal = MODE_GRAB_INPUT;
                else
                    conf.modal = 0;
                end
                set_video_mode( resx, resy ); //MODE_GRAB_INPUT);
            end
        end
        if ( !conf.modal )
            alpha = 0;
        else
            alpha = 255;
        end
        frame;
    until ( prota.est != 1 )
end


process bsync()
begin
    file = prota.file;
    graph = 11;
    x = 290;
    y = 164;
    z = -10;
    repeat
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                if ( !conf.vsync )
                    conf.vsync = MODE_WAITVSYNC;
                else
                    conf.vsync = 0;
                end
                set_video_mode( resx, resy );
            end
        end
        if ( !conf.vsync )
            alpha = 0;
        else
            alpha = 255;
        end
        frame;
    until ( prota.est != 1 )
end


process b2x()
    private
        int wx, wy;
begin
    file = prota.file;
    graph = 11;
    x = 290;
    y = 146;
    z = -10;
    repeat
        if ( !conf.fullsc )
            if ( collision( type mouse ) and mouse.left )
                repeat
                    frame;
                until ( !mouse.left )
                if ( collision( type mouse ))
                    wx = 320;
                    wy = 240;
                    if ( conf.m2x == 0 )
                        conf.m2x = 1;
                        conf.reesc = -1;
                    else
                        conf.m2x = 0;
                        conf.reesc = 06400480;
                    end
                    set_video_mode( resx, resy );
                end
            end
        end
        if ( !conf.m2x )
            alpha = 0;
        else
            alpha = 255;
        end
        if ( conf.fullsc )
            alpha = 255;
            graph = 19;
        else
            graph = 11;
        end
        frame;
    until ( prota.est != 1 )
end


process bsize()
    private
        int wx, wy;
begin
    file = prota.file;
    x = 285;
    y = 124;
    z = -10;
    repeat
        if ( !conf.m2x and !conf.fullsc )
            if ( collision( type mouse ) and mouse.left )
                repeat
                    frame;
                until ( !mouse.left )
                if ( collision( type mouse ))
                    if ( conf.reesc == -1 )
                        conf.reesc = 06400480;
                        wx = 320;
                        wy = 240;
                    elseif ( conf.reesc == 06400480 )
                        conf.reesc = 09600720;
                        wx = 480;
                        wy = 360;
                    elseif ( conf.reesc == 09600720 )
                        conf.reesc = -1;
                        wx = 160;
                        wy = 120;
                    end
                    set_video_mode( resx, resy );
                end
            end
            switch ( conf.reesc )
                case -1:
                    graph = 12;
                end
                case 06400480:
                    graph = 13;
                end
                case 09600720:
                    graph = 14;
                end
            end
        else
            graph = 15;
        end
        frame;
    until ( prota.est != 1 )
end


process sombracursor()
begin
    file = prota.file;
    graph = 9;
    z = -300;
    alpha = 150;
    flags = B_SBLEND;
    loop
        x = mouse.x;
        y = mouse.y;
        frame;
    end
end


process go()
begin
    gob();
    frame( 3000 );

    fade(255,255,255,255,1000/DEFAULT_FPS); // ... jjp corregir! fade(200,200,200,64);
    paralo( 300 );
    fade_on(1000/DEFAULT_FPS); // ... jjp corregir! fade(100,100,100,64);

    file = gfpg;
    graph = 22;
    y = 120;
    x = 160;
    paralo( 3000 );
    control();
    repeat
        subest++;
        x -= subest;
        frame;
    until ( region_out( id, 0 ))
end


process gob()
begin
    file = gfpg;
    frame( 3000 );
    graph = 23;
    y = 121;
    x = 160;
    paralo( 3000 );
    repeat
        subest++;
        x += subest;
        frame;
    until ( region_out( id, 0 ))
end


process skip()
begin
    file = gfpg;
    graph = 18;
    x = 318;
    y = 2;
    alpha = 0;
    z = -300;
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    repeat
        frame;
    until ( collision( type mouse ) and mouse.left )
    father.est = 1;
    repeat
        alpha = clamp( alpha-10, 0, 255 );
        frame;
    until ( alpha == 0 )
end


process xirin( double x, y )
    private
        int vy;
begin
    file = father.file;
    graph = 6;
    repeat
        y += vy / 8;
        frame;
        vy++;
        angle += 1000;
    until ( region_out( id, 0 ))
end


process xeri0()
begin
    file = father.file;
    graph = 16;
    size = 120;
    y = -10;
    x = 188;
    z = 100;
    repeat
        y += 1;
        angle -= 10000;
        size--;
        frame;
    until ( size == 0 )
end

process final()
    private
        byte cabreo[] = 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10;
        int s;
begin
    conf.gameclear = 1;
    mouse.graph = 0;
    file = fpg_load( "./data/finale.fpg" );
    pll = sound_load( "./data/pll.wav" );
    cabe = sound_load( "./data/cabe.wav" );
    corkw = sound_load( "./data/cork.wav" );
    drollw = sound_load( "./data/droll.wav" );
    finm = sound_load( "./data/finm.wav" );
    //cabreohw=sound_load("./data/cabreoh.wav");
    sound_play( finm, -1 );
    put_screen( file, 12 );
    graph = 13;
    x = 188;
    y = 111;
    size = 180;
    sound_play( aak, 0 );
    xeri0();
    repeat
        size--;
        frame;
    until ( size == 0 )
    dust2( x, y );
    dust2( x + 5, y + 5 );
    dust2( x -5, y -5 );
    dust2( x + 3, y -8 );
    dust2( x -3, y + 8 );
    dust2( x + 5, y -5 );
    dust2( x -5, y + 5 );
    sound_play( aak2, 0 );
    sound_play( cabe, 0 );
    paralo( 15000 );
    size = 100;
    //put_screen(file,11);
    z = 10;
    graph = 4;
    y = 120;
    x = 567;
    paralo( 5000 );
    repeat
        x -= s / 8;
        s++;
        if ( x < 320 )
            x = 320;
        end
        frame;
    until ( x == 320 )
    sound_play( saltowav, 0 );
    paralo( 15000 );
    graph = 5;
    xirin( 100, 129 );
    sound_play( pll, 0 );
    repeat
        frame;
    until ( !get_id( type xirin ))
    paralo( 10000 );
    put_screen( file, 1 );
    graph = 0;
    sonidf( saltowav1 );
    paralo( 15000 );
    s = sound_play( drollw, 0 );
    repeat
        if ( z == 1 )
            z = 2;
        else
            z = 1;
        end
        put_screen( file, z );
        est++;
        frame;
    until ( !sound_is_playing( s ))
    est = 0;
    sound_play( corkw, 0 );

    fade(255,255,255,255,1000/DEFAULT_FPS); // ... jjp corregir! fade(200,200,200,64);
    paralo( 300 );
    fade_on(1000/DEFAULT_FPS); // ... jjp corregir! fade(100,100,100,64);

    put_screen( file, 3 );
    paralo( 20000 );
    sound_play( cabreowav2, -1 );
    thend();
    repeat
        put_screen( file, cabreo[ est ] );
        est++;
        if ( est + 1 > sizeof( cabreo ))
            est = 0;
        end
        subest++;
        frame;
    until ( subest => 240 )
    graph = 15;
    alpha = 0;
    x = 5;
    y = 235;
    if ( os_id != OS_GP2X_WIZ )
        mouse.graph = 999;
    end
    if ( perfect )
        perfectofin();
        conf.fase[ 7 ] = 2;
        conf.fase[ 8 ] = 2;
        conf.fase[ 9 ] = 2;
    end
    if ( !conf.gameclear )
        unlockgrav();
        conf.gameclear = 1;
    end
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        put_screen( file, cabreo[ est ] );
        est++;
        if ( est + 1 > sizeof( cabreo ))
            est = 0;
        end
        subest++;
        frame;
    until ( collision( type mouse ) and mouse.left )
    fade_off( 500 );
    repeat
        put_screen( file, cabreo[ est ] );
        est++;
        if ( est + 1 > sizeof( cabreo ))
            est = 0;
        end
        z--;
        frame;
    until ( z == -50 )
    clear_screen();
    fpg_unload( file );
    sound_unload( corkw );
    sound_unload( pll );
    sound_unload( cabe );
    sound_unload( drollw );
    sound_unload( finm );
    let_me_alone();
    jkeys_set_default_keys();
    jkeys_controller();
    fade_on( 500 );
    prota = menu();
end


process perfectofin()
begin
    frame(0);
    if ( conf.fase[ faseactual ] != 2 )
        graph = 20;
    else
        graph = 9;
    end
    file = gfpg;
    x = 5;
    y = 10;
    est = graph;
    loop
        graph = est;
        paralo( 600 );
        graph = 0;
        paralo( 600 );
    end
end


process unlockgrav()
begin
    frame(0);
    file = gfpg;
    x = 5;
    y = 30;
    loop
        graph = 21;
        paralo( 600 );
        graph = 0;
        paralo( 600 );
    end
end


process thend()
begin
    file = father.file;
    graph = 14;
    alpha = 0;
    y = 0;
    x = 320;
    loop
        frame;
        alpha = clamp( alpha+10, 0, 255 );
    end
end


process nubes()
begin
    scroll[ 1 ].follow = -1;
    loop
        scroll[ 1 ].y0 += 10;
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process labof()
begin
    x = 160;
    y = 240;
    graph = 25;
    file = levelm;
    paralo( 5000 );
    sound_stop( -1 );
    repeat
        x--;
        frame;
    until ( x == 60 )
    escom();
    repeat
        frame;
    until ( !get_id( type escom ))
end


process escom()
begin
    x = 128;
    y = 113;
    graph = 26;
    file = levelm;
    est = 12;
    explot( x, y );
    repeat
        subest++;
        if ( subest == 2 )
            subest = 0;
            x += est;
            if ( est > 1 )
                est--;
            end
        end
        frame;
    until ( x > 240 )
    paralo( 2500 );
    fade_off( 500 );
    paralo( 5000 );
end


process esc( double y )
begin
    ctype = c_scroll;
    cnumber = c_0;
    file = levelm;
    z = 100;
    loop
        angle = rand( 0, 360 ) * 1000;
        graph = rand( 5, 8 );
        x = rand( 0, 320 );
        flags = rand( 0, 3 );
        size = rand( 50, 100 );
        est = rand( 1, 3 );
        repeat
            y -= est;
            angle += 1000;
            repeat
                frame;
            until ( pausa == 0 )
        until ( region_out( id, 0 ) and y < 0 )
        y = 300 + rand( 0, 100 );
    end
end


process marca( double x, y )
begin
    file = gfpg;
    ctype = c_scroll;
    cnumber = c_0;
    flags = B_ABLEND;
    //z=1000;
    graph = 998;
    repeat
        repeat
            frame;
        until ( pausa == 0 )
    until ( collision( prota ) or prota.est != salto or( get_id( type marca )) != id )
    repeat
        alpha = clamp( alpha-30, 0, 255 );
        repeat
            frame;
        until ( pausa == 0 )
    until ( alpha == 0 )
end


function sonidr( int wv, double x )
    private
        int l, r, soni;
begin
    soni = sound_play( wv, 0 );
    r = abs(( x * 255 ) / resx );
    if ( r > 255 )
        r = 255;
    end
    l = 255 - r;
    set_panning( voz, l, r );
end


process monofin()
    private
        int coli, v, an, mar, k;
        byte mbf = 1;
begin
    resolution = 100;
    ctype = c_scroll;
    cnumber = c_0;
    // file = monofpg;
    graph = 21;
    scroll.x0 = 0;
    scroll.y0 = 0;
    asignapal();
    x = 240 * resolution;
    y = 60 * resolution;
    z = -10;
    invul = 0;
    loop
        //x=mouse.x; y=mouse.y;
        if ( mouse.left )
            if ( !mbf )
                mbf = 1;
                if ( est == 0 )
                    est = 1;
                    mar = marca( mouse.x, mouse.y );
                    if ( v == 0 )
                        an = fget_angle( x, y, mouse.x * resolution, mouse.y * resolution );
                    else
                        an = near_angle( an, fget_angle( x, y, mar.x * resolution, mar.y * resolution ), 10000 );
                    end
                else
                    mar = marca( mouse.x, mouse.y );
                end
            end
            //mox=mouse.x; moy=mouse.y;
        else
            mbf = 0;
        end
        if ( est == 1 )
            if ( exists( mar ))
                an = near_angle( an, fget_angle( x, y, mar.x * resolution, mar.y * resolution ), 5000 );
            end
            if ( v < 500 )
                v += 4;
            end
            if ( collision( type marca ))
                est = 0;
            end
        end
        if ( est == 0 )
            if ( v > 0 )
                v -= 5;
            end
            if ( v < 0 )
                v = 0;
            end
        end
        if ( est < 2 )
            k = 0;
            xadvance( an, v );
            subest++;
            if ( subest == 3 )
                subest = 0;
                if ( graph == 21 )
                    graph = 20;
                else
                    graph = 21;
                end
            end
            if (( coli = collision( type misilf )) and invul == 0 )
                if ( coli.est == 1 )
                    coli.est = 0;
                    subest = 0;
                    sonidr( aak, x / resolution );
                    ener--;
                    if ( ener == 0 )
                        vidas--;
                        est = 4;
                    else
                        est = 2;
                    end
                end
            end
        end
        if ( est == 2 )
            graph = 39;
            perfect = 0;
            k++;
            if ( k % 2 == 0 )
                x += 200;
            else
                x -= 200;
            end
            if ( k >= 60 )
                est = 0;
                invul = tinvul;
            end
        end
        if ( est == 4 )
            graph = 39;
            perfect = 0;
            angle += 10000;
            subest++;
            if ( subest >= 120 )
                if ( vidas != -1 )
                    invul = tinvul;
                    est = 0;
                    subest = 0;
                    ener = 3;
                    energia( 1 );
                    energia( 2 );
                    energia( 3 );
                else
                    gover();
                    loop
                        y -= resolution / 2;
                        angle += 10000;
                        frame;
                    end
                end
            end
        else
            angle = 0;
        end
        if ( x > 310 * resolution )
            x = 310 * resolution;
        end
        if ( x < 10 * resolution )
            x = 10 * resolution;
        end
        if ( y > 240 * resolution )
            y = 240 * resolution;
        end
        if ( y < 10 * resolution )
            y = 10 * resolution;
        end
        alpha = clamp( alpha+20, 0, 255 );
        if ( invul != 0 )
            if ( invul % 15 == 0 )
                alpha = 50;
            end
            invul--;
        end
        if ( graph == 39 )
            flags = B_HMIRROR;
        else
            flags = 0;
        end
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process marcb( double x, y )
begin
    file = gfpg;
    graph = 998;
    alpha = 0;
    repeat
        frame;
    until ( collision( type cfall ))
end


process marc( double x, y )
begin
    file = gfpg;
    graph = 998;
    alpha = 0;
    repeat
        frame;
    until ( collision( type cfall ))
end


process cfall()
    private
        int coli, mox, moy, v = 200, an, mar, k, energ = 6;
begin
    resolution = 100;
    ctype = c_scroll;
    cnumber = c_0;
    file = levelm;
    graph = 21;
    x = 80 * resolution;
    y = 60 * resolution;
    repeat
        if ( est == 0 )
            angle = 0;
            est = 1;
            mox = rand( 20, 300 );
            moy = rand( 20, 220 );
            if ( v > 0 )
                v -= 5;
            end
            if ( v < 0 )
                v = 0;
            end
            if ( v == 0 )
                an = fget_angle( x, y, mox * resolution, moy * resolution );
            else
                an = near_angle( an, fget_angle( x, y, mox * resolution, moy * resolution ), 5000 );
            end
        else
            if ( !exists( mar ))
                mar = marcb( mox, moy );
            end
        end
        //mox=mouse.x; moy=mouse.y;
        if ( est == 1 )
            angle = 0;
            k++;
            if ( exists( mar ))
                an = near_angle( an, fget_angle( x, y, mar.x * resolution, mar.y * resolution ), 5000 );
            end
            if ( v < 200 )
                v += 2;
            end
            if ( collision( mar ))
                est = 0;
            end
            if ( k > 180 )
                k = 0;
                est = 2;
                angle = -90000;
            end
        end
        if ( est < 2 )
            subest++;
            if ( subest == 3 )
                subest = 0;
                if ( prota.x < x )
                    if ( graph == 21 )
                        graph = 20;
                    else
                        graph = 21;
                    end
                else
                    if ( graph == 121 )
                        graph = 120;
                    else
                        graph = 121;
                    end
                end
            end
            xadvance( an, v );
        end
        if ( est == 2 )
            graph = 22;
            k++;
            angle = near_angle( angle, get_angle( prota ), 5000 );
            if ( k >= 60 )
                est = 3;
                k = 0;
            end
        end
        if ( est == 3 )
            k++;
            angle = near_angle( angle, get_angle( prota ), 5000 );
            if ( graph == 22 )
                graph = 23;
            else
                graph = 22;
            end
            //if(k%2==0)x+=100; else x-=100; end
            if ( k == 60 )
                advance( 40 * resolution );
                misilf( x, y, angle );
                advance( -40 * resolution );
            end
            if ( k >= 90 )
                est = 0;
                k = 0;
            end
        end
        if (( coli = collision( type misilf )) and !get_id( type gover ))
            if ( coli.est == 1 )
                est = 4;
                sonidr( no, x / resolution );
                k = 0;
                coli.est = 0;
                energ--;
            end
        end
        if ( est == 4 )
            angle = 0;
            graph = 24;
            k++;
            if ( k % 2 == 0 )
                x += 200;
            else
                x -= 200;
            end
            if ( k >= 60 )
                est = 0;
            end
        end
        if ( x > 310 * resolution )
            x = 310 * resolution;
        end
        if ( x < 10 * resolution )
            x = 10 * resolution;
        end
        if ( y > 240 * resolution )
            y = 240 * resolution;
        end
        if ( y < 10 * resolution )
            y = 10 * resolution;
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( energ == 0 )
    //est=10;
    sonidr( alar, x / resolution );
    angle = 0;
    graph = 9;
    subest = 0;
    subest = 20;
    repeat
        dust3( x + ( rand( -40, 40 ) * resolution ), y + ( rand( -30, 30 ) * resolution ));
        repeat
            frame;
        until ( pausa == 0 )
        y += subest * resolution / 2;
        subest--;
    until ( subest == 0 )
    repeat
        /*subest++;
if(subest==2)
	energ--;
	y+=energ*resolution;
	subest=0;*/
        dust3( x + ( rand( -40, 40 ) * resolution ), y + ( rand( -30, 30 ) * resolution ));
        //end
        repeat
            frame;
        until ( pausa == 0 )
        y -= resolution / 2;
    until ( region_out( id, 0 ) and y < 0 )
    resolution = 0;
    x = 160;
    z = -100;
    graph = 27;
    y = -100;
    repeat
        angle += 1000;
        y += 1;
        repeat
            frame;
        until ( pausa == 0 )
    until ( y > 280 )
    //fade(0,0,0,1);
    fade_off( 1000 );
    music_fade_off( 1000 );
    paralo( 5000 );
    let_me_alone();
    jkeys_set_default_keys();
    jkeys_controller();
    scroll_stop( 0 );
    scroll_stop( 1 );
    clear_screen();
    fpg_unload( level );
    fpg_unload( levelm );
    fpg_unload( explofpg );
    fpg_unload( misfpg );
    sound_unload( shotwav );
    sound_unload( bomw );
    sound_unload( no );
    sound_unload( ris );
    sound_unload( alar );
    music_unload( canc );
    fade_on( 500 );
    paralo( 5000 );
    final();
end


process misil( double x, y, int angle )
    private
        int tail;
begin
    est = 1;
    file = misfpg;
    ctype = c_scroll;
    cnumber = c_0;
    graph = 10;
    sonidf( shotwav );
    tail = cola();
    for ( z = 0; z < 10; z++ )
        dust2( x + rand( -10, 10 ), y + rand( -10, 10 ));
    end
    z = 13;
    /*dust(x+3,y-3);
dust(x-3,y+3);*/
    //dust(x,y);
    repeat
        angle = near_angle( angle, get_angle( prota ), angmis );
        advance( admis );
        if ( map_get_pixel( level, 1, x, y ) != 0 )
            est = 0;
        end
        if ( get_dist( prota ) > 640 )
            signal( id, s_kill_tree );
        end
        subest++;
        if ( subest == 5 )
            subest = 0;
            graph++;
            if ( graph == 15 )
                graph = 10;
            end
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( est == 0 or father.est == 10 )
    subest = 0;
    signal( tail, s_kill );
    //if(!region_out(id,0)) sonidf(bomw); end
    sonidf( bomw );
    graph = 0;
    file = explofpg;
    flags = B_ABLEND;
    z = -100;
    repeat
        subest++;
        if ( subest == 1 )
            subest = 0;
            graph++;
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( graph == 37 )
    subest = 0;
    graph = 0;
    repeat
        subest++;
        repeat
            frame;
        until ( pausa == 0 )
    until ( subest == 120 )
end


process misilf( double x, y, int angle )
    private
        int tail, soni;
begin
    est = 1;
    resolution = 100;
    file = misfpg;
    ctype = c_scroll;
    cnumber = c_0;
    graph = 10;
    sonidr( shotwav, x / resolution );
    tail = cola();
    for ( z = 0; z < 10; z++ )
        dust2( x + rand( -10, 10 ), y + rand( -10, 10 ));
    end
    z = 13;
    /*dust(x+3,y-3);
dust(x-3,y+3);*/
    //dust(x,y);
    repeat
        angle = near_angle( angle, get_angle( prota ), angmis );
        advance( admis * resolution );
        //if(map_get_pixel(level, 1, x, y)!=0) est=0; end
        //if(get_dist(prota)>640) signal(id, s_kill_tree); end
        subest++;
        if ( subest == 5 )
            subest = 0;
            graph++;
            if ( graph == 15 )
                graph = 10;
            end
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( est == 0 or father.graph == 9 )
    subest = 0;
    signal( tail, s_kill );
    //if(!region_out(id,0)) sonidf(bomw); end
    sonidr( bomw, x / resolution );
    graph = 0;
    file = explofpg;
    flags = B_ABLEND;
    z = -100;
    repeat
        subest++;
        if ( subest == 1 )
            subest = 0;
            graph++;
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( graph == 37 )
    subest = 0;
    graph = 0;
    repeat
        subest++;
        repeat
            frame;
        until ( pausa == 0 )
    until ( subest == 120 )
end


process chisme()
    private
        int coli, ct, magni;
begin
    ctype = c_scroll;
    cnumber = c_0;
    file = levelm;
    graph = 10;
    x = 0;
    y = 450;
    z = 90;
    reflecab();
    ct = cienti();
    repeat
        frame;
    until ( scroll.y0 == 450 )
    sound_play( ris, 0 );
    music_play( canc, -1 );
    finfase = 0;
    repeat
        coli++;
        repeat
            frame;
        until ( pausa == 0 )
    until ( coli == 470 )
    repeat
        ct.est = 0;
        if ( scroll.y0 == 450 and !get_id( type misil ))
            subest = 0;
            misil( 180, 503, 0 );
            misil( 160, 503, 180000 );
            misil( 170, 507, -90000 );
        end
        if ( subest < 30 )
            subest++;
        end
        if ( coli = collision( type misil ))
            if ( subest >= 30 and coli.est == 1 )
                subest = 0;
                coli.est = 0;
                est = 60;
                magni++;
                sound_play( no, 0 );
            end
        end
        if ( est != 0 )
            tremor( magni );
            est--;
            if ( est == 10 )
                est = 9;
            end
            if ( graph == 10 )
                graph = 11;
            else
                graph = 10;
            end
            ct.est = 1;
        else
            graph = 10;
            if ( prota.est == dano or invul != 0 or prota.est == muerto )
                ct.est = 2;
            end
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( magni == 10 )
    est = 10;
    frame;
    est = 0;
    repeat
        subest = 0;
        est++;
        if ( est == 3 )
            sound_play( alar, 0 );
        end
        repeat
            if ( subest == 0 )
                explot( 96, 485 );
            end
            if ( subest == 30 )
                explot( 242, 458 );
            end
            if ( subest == 60 )
                explot( 198, 500 );
            end
            if ( subest == 90 )
                explot( 96, 490 );
            end
            if ( subest == 120 )
                explot( 69, 463 );
            end
            if ( subest == 150 )
                explot( 281, 497 );
            end
            if ( subest == 180 )
                explot( 158, 455 );
            end
            //if(subest==210) explot(96,490); end
            subest++;
            tremor( 15 );
            if ( graph == 10 )
                graph = 11;
            else
                graph = 10;
            end
            prota.subest = hoook;
            repeat
                frame;
            until ( pausa == 0 )
        until ( subest == 255 )
    until ( est == 3 )
    finfase = 1;
    paralo( 5000 );
    signal( id, s_kill_tree );
end


process explot( double x, y )
begin
    ctype = father.ctype;
    cnumber = father.cnumber;
    file = explofpg;
    flags = B_ABLEND;
    sonidf( bomw );
    repeat
        subest++;
        if ( subest == 2 )
            subest = 0;
            graph++;
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( graph == 37 )
end


process tremor( mag )
begin
    x = rand( - mag, mag );
    y = rand( - mag, mag );
    scroll.x0 += x;
    scroll.y0 += y;
    repeat
        frame;
    until ( pausa == 0 )
    scroll.x0 = 10;
    scroll.y0 = 450;
end


process cienti()
    private
        byte preest;
begin
    ctype = c_scroll;
    cnumber = c_0;
    file = levelm;
    graph = 13;
    x = 170;
    y = 496;
    z = 89;
    loop
        if ( scroll.y0 < 400 )
            est = 2;
        end
        subest++;
        switch ( est )
            case 0:
                if ( subest >= 20 )
                    subest = 0;
                    graph = rand( 13, 15 );
                end
            end
            case 1:
                if ( subest >= 10 )
                    subest = 0;
                    if ( graph == 16 )
                        graph = 17;
                    else
                        graph = 16;
                    end
                end
            end
            case 2:
                if ( subest >= 10 )
                    subest = 0;
                    if ( graph == 18 )
                        graph = 19;
                    else
                        graph = 18;
                    end
                end
            end
        end
        repeat
            frame;
        until ( pausa == 0 )
        preest = est;
    end
end


process reflecab()
begin
    ctype = c_scroll;
    cnumber = c_0;
    file = levelm;
    graph = 12;
    x = 146;
    y = 460;
    z = 88;
    flags = B_ABLEND;
    alpha = 180;
    loop
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process camara2()
begin
    scroll.x0 = 10;
    scroll.y0 = 10;
    repeat
        if ( prota.y > 135 and scroll.y0 != 450 )
            scroll.y0 = prota.y -115;
        end
        if ( scroll.y0 > 450 )
            scroll.y0 = 450;
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( scroll.y0 == 450 )
    loop
        frame;
    end
    loop
        x = rand( -10, 10 );
        y = rand( -10, 10 );
        scroll.x0 += x;
        scroll.y0 += y;
        repeat
            frame;
        until ( pausa == 0 )
        scroll.x0 -= x;
        scroll.y0 -= y;
    end
end

process trayec(double x, y, int alpha, ssize)
begin
    size = ssize;
    z = prota.z+1;
    ctype = c_scroll;
    cnumber = c_0;
    file = gfpg;
    graph = 994;
    //flags = 16;
    frame;
end

process trayectoria()
private
    int correcsalt;
    double vx, vy, fx, fy;
    double fxint, fyint;
    double steps;
    double lastx, lasty, newx, newy;
    byte talpha;
begin
    x = prota.x;
    y = prota.y;

    if ( est == walljump )
    	correcsalt = 0;
    else
    	correcsalt = 30;
    end

    if(mouse.y + scroll.y0 < y - correcsalt and prota.est != salto and prota.est != dano)
    	if ( conf.grav == 0 )
    		vy = 0.97 * ( sqrt( y - ( mouse.y + scroll.y0 )));
            vx = ((( mouse.x + scroll.x0 ) - x ) / vy ) / 2;
            if ( vx < 0 and vx > -0.4 )
                vx = 0;
            end
            if ( vx > 0 and vx < 0.4 )
                vx = 0;
            end
    	else
    		vy = 1.375 * ( sqrt( y - ( mouse.y + scroll.y0 )));
    		vx = ((( mouse.x + scroll.x0 ) - x ) / vy );
            if ( vx < 0 and vx > -0.5 )
                vx = 0;
            end
            if ( vx > 0 and vx < 0.5 )
                vx = 0;
            end
    	end

		for(steps=1; steps<20; steps+=0.1)
			fx = x;
			fy = y;

			fx += vx;
			fxint = fx;

            newx = fx + 2*vx*steps;
            newy = prota.y - 2*vy*steps;

            talpha = clamp(8 - steps / 4, 0, 255 );
            if ( talpha )
			    trayec(newx, newy, talpha, 50 + steps*8);
            end

			if ( conf.grav == 0 )
				vy -= 0.05;
			else
				vy -= 0.1;
			end

		end
	end
end

process monete( double x, y )
    private
        double vx, vy, fx, fy;
        int fyint, fxint, direc, coli, correcsalt, xx;
        byte walk[] = 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2;
        byte cabreo[] = 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10;
        byte saltos[] = 33, 34, 35, 36, 37, 38, 37, 36, 35, 34;
        byte ate[] = 32, 32, 32, 31, 31, 30;
        byte i, t, preest, mbf = 1, c, obst, fin; // invul;
begin
    if ( get_id( type caged ))
        vy = 10;
        est = salto;
    end
    frame( 0 );
    perfect = 1;
    //scroll.camera=id;
    ctype = c_scroll;
    cnumber = c_0;
    //file = monofpg;
    asignapal();
    graph = 2;
    //suelo=resy-5;
    //suelo=870;
    //y=fy=suelo; x=fx=(resx/2);
    fx = x;
    fy = y;
    mouse.file = gfpg;
    if ( os_id != OS_GP2X_WIZ )
        mouse.graph = 999;
    end
    //est=salto;
    //colors_get(1,15,16, &color);
    repeat
        realx = x - scroll.x0;
        realy = y - scroll.y0;
        preest = est;
        if ( !get_id( type caged ) and !get_id( type go ) and !(( jkeys_state[ _JKEY_L ] or jkeys_state[ _JKEY_R ] ) and mouse.left ))
            if ( mouse.left )
                if ( mbf != 1 )
                    mbf = 1;
                    if ( est == walljump )
                        correcsalt = 0;
                    else
                        correcsalt = 30;
                    end
                    if (( est == pie or est == walking or( est == walljump and(( flags == 0 and mouse.x + scroll.x0 < x ) or( flags == B_HMIRROR and mouse.x + scroll.x0 > x )))) and mouse.y + scroll.y0 < y - correcsalt )
                        marca( mouse.x + scroll.x0, mouse.y + scroll.y0 );
                        est = salto;
                        //			vy=1.375*(sqrt(y-(mouse.y+scroll.y0)));
                        //			vx=(((mouse.x+scroll.x0)-x)/vy);
                        //if(obst==1) graph=1; end
                        switch ( rand( 0, 1 ))
                            case 0:
                                sonid( saltowav );
                            end
                            case 1:
                                sonid( saltowav1 );
                            end
                        end
                        if ( conf.grav == 0 )
                            vy = 0.97 * ( sqrt( y - ( mouse.y + scroll.y0 )));
                            vx = ((( mouse.x + scroll.x0 ) - x ) / vy ) / 2;
                            if ( vx < 0 and vx > -0.4 )
                                vx = 0;
                            end
                            if ( vx > 0 and vx < 0.4 )
                                vx = 0;
                            end
                        else
                            vy = 1.375 * ( sqrt( y - ( mouse.y + scroll.y0 )));
                            vx = ((( mouse.x + scroll.x0 ) - x ) / vy );
                            if ( vx < 0 and vx > -0.5 )
                                vx = 0;
                            end
                            if ( vx > 0 and vx < 0.5 )
                                vx = 0;
                            end
                        end
                        if ( vx > 0 )
                            flags = 0;
                        elseif ( vx < 0 )
                            flags = B_HMIRROR;
                        end
                    end
                end
            else
                mbf = 0;
            end
        end
        fx += vx;
        fxint = fx;

	trayectoria();

        repeat
            if ( flags == 0 )
                direc = 10;
            else
                direc = -10;
            end
            //if(est==dano) direc*=-1; end
            if ( map_get_pixel( level, 1, x + direc + (( abs( vx ) / vx )), y -1 ) == pare )
                //if(est==dano) x+=(direc/-1); end
                fx = x; //vy=0; fy=y;
                //vy/=2;
                obst = 1;
                break;
            else
                obst = 0;
                /*if(graph==6 and vy<0)
					vx=0;
					if(flags==0) x-=2; fx=x; else x+=2; fx=x; end
					x=fxint;
				end*/
            end
            if ( x < fxint )
                x++;
            end
            if ( x > fxint )
                x--;
            end
        until ( x == fxint )
        //x=fx; //y=fy;
        if ( y > 0 )
        end
        //if(y>suelo) vx=0; est=pie; y=suelo; fy=suelo; end
        //if(x<0) x=0; fx=0; elseif(x>resx) fx=resx; x=resx; end
        if ( preest != est )
            i = 0;
            t = 0;
        end
        switch ( est )
            case salto:
                fy -= vy;
                fyint = fy;
                repeat
                    if ( y < fyint )
                        y++;
                    end
                    if ( y > fyint )
                        y--;
                    end
                    if ( map_get_pixel( level, 1, x, y ) == pincha )
                        if ( invul == 0 and est != dano and est != muerto )
                            est = dano;
                            break;
                        end
                    end
                    if (( map_get_pixel( level, 1, x, y + 1 ) == chan and vy < 0 ) and !( down and map_get_pixel( level, 1, x, y + 2 ) == 0 ))
                        if ( left )
                            est = walking;
                            vx = - wlkspd;
                        end
                        if ( right )
                            est = walking;
                            vx = wlkspd;
                        end
                        if ( !right and !left )
                            est = pie;
                            if ( vy < -10 )
                                subest = ater;
                            end
                        end
                        vx = 0;
                        vy = 0;
                        fy = y;
                        break;
                    elseif ((( map_get_pixel( level, 1, x, y -10 ) == techo ) or( map_get_pixel( level, 1, x + direc, y -10 ) == techo )) and vy > 0 )
                        sonidf( techowav );
                        vy = -1;
                        fy = y;
                        break;
                    end
                until ( y == fyint )
                if ( conf.grav == 0 )
                    vy -= 0.5;
                else
                    vy--;
                end
                if ( obst == 1 )
                    est = walljump;
                    t = 0;
                end
                /*if(vy<0 and obst==1) vy-=0.05;
			else vy-=0.5;
		end*/
                /*if(obst==1)

			if(flags==0 and left) vx=0; x-=50; fx=x;
			elseif(flags==B_HMIRROR and right) vx=0; x+=50; fx=x;
			else
			graph=6; if(t%2==0) dust(x,y); fx=x;
			end

			end
		end*/
            end
            case pie:
                vx = 0;
                if ( left )
                    est = walking;
                    t = 3;
                end
                if ( right )
                    est = walking;
                end
                if ( map_get_pixel( level, 1, x, y + 1 ) != chan )
                    est = salto;
                    vy = 0;
                end
                //		while(map_get_pixel(level, 1, x, y)==chan) y--; fy--; end
            end
            case walking:
                if ( vx => 0 and !right )
                    if ( left )
                        vx = - wlkspd;
                    else
                        est = pie;
                        vx = 0;
                    end
                end
                if ( vx =< 0 and !left )
                    if ( right )
                        vx = wlkspd;
                    else
                        est = pie;
                        vx = 0;
                    end
                end
                if (( jkeys_state[ _JKEY_L ] or jkeys_state[ _JKEY_R ] ))
                    est = pie;
                    vx = 0;
                    right = 0;
                    left = 0;
                end
                if ( map_get_pixel( level, 1, x, y + 1 ) != chan )
                    est = salto;
                    vy = 0;
                    if ( direc > 0 )
                        vx = wlkspd;
                    else
                        vx = - wlkspd;
                    end
                end
                while ( map_get_pixel( level, 1, x, y ) == chan )
                    y--;
                    fy--;
                end
            end
            case walljump:
                fy -= vy;
                fyint = fy;
                t++;
                repeat
                    if ( y < fyint )
                        y++;
                    end
                    if ( y > fyint )
                        y--;
                    end
                    if ( map_get_pixel( level, 1, x, y + 1 ) == chan and vy < 0 )
                        vx = 0;
                        vy = 0;
                        fy = y;
                        if ( left )
                            est = walking;
                            vx = - wlkspd;
                        end
                        if ( right )
                            est = walking;
                            vx = wlkspd;
                        end
                        if ( !right and !left )
                            est = pie;
                        end
                        break;
                    elseif ( map_get_pixel( level, 1, x, y -10 ) == techo and vy > 0 )
                        vy = -1;
                        fy = y;
                        break;
                    end
                until ( y == fyint )
                if ( obst == 0 )
                    est = salto;
                    if ( vy <= 0 )
                        vx = 0;
                        if ( flags == 0 )
                            x -= 10;
                            fx = x;
                        else
                            x += 10;
                            fx = x;
                        end
                    end
                end
                if ( t % 2 == 0 )
                    dust( x + direc, y );
                    fx = x;
                end
                if ( left and flags == 0 )
                    vx = -0.5;
                    obst = 0;
                    est = salto;
                end
                if ( right and flags == B_HMIRROR )
                    vx = 0.5;
                    obst = 0;
                    est = salto;
                end
                if ( vy > 0 )
                    if ( conf.grav == 0 )
                        vy -= 0.5;
                    else
                        vy--;
                    end
                else
                    vy -= 0.025;
                end
            end
            case dano:
                perfect = 0;
                invul = 0;
                if ( graph != 39 )
                    ener--;
                    if ( ener != 0 )
                        switch ( rand( 0, 2 ))
                            case 0:
                                sonid( cabreowav );
                            end
                            case 1:
                                sonid( cabreowav2 );
                            end
                            case 2:
                                sonid( cabreowav3 );
                            end
                        end
                    else
                        vidas--;
                        sonid( aak2 );
                    end
                    if ( flags == 0 )
                        vx = -5;
                    else
                        vx = 5;
                    end
                    vy = 7;
                end
                graph = 39;
                fy -= vy;
                fyint = fy;
                repeat
                    if ( y < fyint )
                        y++;
                    end
                    if ( y > fyint )
                        y--;
                    end
                    if ( map_get_pixel( level, 1, x, y + 1 ) == chan and vy < 0 )
                        if ( ener > 0 )
                            invul = tinvul;
                            //if(obst==1)x+=(direc/-1)/2; fx=x; end
                            if ( left )
                                est = walking;
                                vx = - wlkspd;
                            end
                            if ( right )
                                est = walking;
                                vx = wlkspd;
                            end
                            if ( !right and !left )
                                est = pie;
                                subest = hoook;
                                if ( flags == 0 )
                                    flags = B_HMIRROR;
                                else
                                    flags = 0;
                                end
                                /*switch (rand(0,2))
										case 0:
											sonid(cabreowav);
										end

										case 1:
											sonid(cabreowav2);
										end

										case 2:
											sonid(cabreowav3);
										end
						end*/
                                /*if(vy<-10) subest=ater; end*/
                            end
                        else
                            t = 0;
                            est = muerto;
                            sonid( aak );
                        end
                        vx = 0;
                        vy = 0;
                        fy = y;
                        break;
                    elseif ( map_get_pixel( level, 1, x, y -10 ) == techo and vy > 0 )
                        //	sonidf(techowav);
                        vy = -1;
                        fy = y;
                        break;
                    end
                until ( y == fyint )
                vy -= 0.5;
                //if(obst==1) est=walljump; t=0; end
            end
            case muerto:
                if ( vidas >= 0 )
                    if ( rand( 0, 1 ))
                        if ( graph == 52 )
                            graph = 53;
                        else
                            graph = 52;
                        end
                    end
                    t++;
                    if ( t == 100 )
                        est = salto;
                        vy = 5;
                        invul = tinvul;
                        if ( ener == 0 )
                            if ( vidas >= 0 )
                                energia( 1 );
                                energia( 2 );
                                energia( 3 );
                                ener = 3;
                            end
                        end
                    end
                else
                    graph = 0;
                    fin = 1;
                end
            end
        end
        if ( down and( est == pie or est == walking ))
            if ( map_get_pixel( level, 1, x, y + 2 ) == 0 )
                est = salto;
                if ( left )
                    vx = - wlkspd;
                elseif ( right )
                    vx = wlkspd;
                end
            end
        end
        switch ( est )
            case salto:
                /*t++;
		//if(preest!=salto) t=4; end
		if(t%4==0) t=0;
			graph=walk[i]; i++;
			if(i+1>sizeof(walk)) i=0; end
		end*/
                fyint = vy;
                if ( vx < 3 and vx > -3 )
                    if ( fyint > 0 )
                        graph = 14;
                    end
                    if ( fyint == 0 )
                        graph = 15;
                    end
                    if ( fyint < 0 and fyint >= -2 )
                        graph = 16;
                    end
                    if ( fyint <= -4 )
                        graph = 17;
                    end
                else
                    if ( fyint > 0 )
                        graph = 18;
                    end
                    if ( fyint == 0 )
                        graph = 19;
                    end
                    if ( fyint < 0 and fyint >= -2 )
                        graph = 20;
                    end
                    if ( fyint <= -4 )
                        graph = 21;
                    end
                end
            end
            case pie:
                switch ( subest )
                    case hoook:
                        //t++;
                        graph = cabreo[ i ];
                        i++;
                        if ( i + 1 > sizeof( cabreo ))
                            i = 0;
                        end
                        if ( !sound_is_playing( voz ))
                            subest = parao;
                            t = 0;
                        end
                    end
                    case parao:
                        graph = 12;
                        t++;
                        i = 0;
                        if ( t == 60 )
                            switch ( rand( 0, 4 ))
                                case 0:
                                    subest = miraiz;
                                    t = 0;
                                end
                                case 1:
                                    subest = mirader;
                                    t = 0;
                                end
                                case 2:
                                    subest = mirarr;
                                    t = 0;
                                end
                                case 3:
                                    subest = parpa;
                                    t = 0;
                                end
                                case 4:
                                    if ( rand( 0, 2 ) == 2 )
                                        subest = hoook;
                                        switch ( rand( 0, 2 ))
                                            case 0:
                                                sonid( cabreowav );
                                            end
                                            case 1:
                                                sonid( cabreowav2 );
                                            end
                                            case 2:
                                                sonid( cabreowav3 );
                                            end
                                        end
                                    else
                                        t = 0;
                                    end
                                end
                                case 5:
                                    subest = uhuh;
                                    t = 0;
                                    sonid( cabreowav3 );
                                end
                            end
                        end
                    end
                    case ater:
                        graph = ate[ t ];
                        t++;
                        if ( t + 1 > sizeof( ate ))
                            subest = parao;
                            t = 0;
                        end
                    end
                    case miraiz:
                        if ( t == 0 )
                            graph = 22;
                        else
                            graph = 23;
                        end
                        t++;
                        if ( t == 60 )
                            subest = parao;
                            t = 54;
                        end
                    end
                    case mirader:
                        if ( t == 0 )
                            graph = 24;
                        else
                            graph = 25;
                        end
                        t++;
                        if ( t == 60 )
                            subest = parao;
                            t = 54;
                        end
                    end
                    case mirarr:
                        if ( t == 0 )
                            graph = 29;
                        else
                            graph = 28;
                        end
                        t++;
                        if ( t == 60 )
                            subest = parao;
                            t = 54;
                        end
                    end
                    case parpa:
                        if ( t < 2 or t > 3 )
                            graph = 26;
                        else
                            graph = 27;
                        end
                        if ( t == 4 )
                            subest = parao;
                            t = 0;
                        end
                        t++;
                    end
                    case uhuh:
                        graph = saltos[ i ];
                        if ( t % 2 == 0 )
                            i++;
                            if ( i + 1 > sizeof( saltos ))
                                i = 0;
                            end
                        end
                        t++;
                        //if(t==60) t=0; i=0; subest=parao; end
                        if ( !sound_is_playing( voz ))
                            subest = parao;
                            t = 0;
                        end
                    end
                end
            end
            case walking:
                /*t++;
		if(preest!=walking) t=4; end*/
                //if(t==4) t=0;
                graph = walk[ i ];
                i++;
                if ( i + 1 > sizeof( walk ))
                    i = 0;
                end
                if ( obst == 1 )
                    graph += 39;
                end
                //end
            end
            case walljump:
                graph = 6;
                t++;
            end
        end
        if ( vx > 0 )
            flags = 0;
        elseif ( vx < 0 )
            flags = B_HMIRROR;
        end
        if ( est != pie )
            subest = parao;
        end
        if ( !mouse.right )
            if ( mouse.y + scroll.y0 >= prota.y -30 and mouse.y + scroll.y0 <= prota.y + 15 and( est == pie or est == walking ))
                mouse.graph = 996;
                if ( mouse.x + scroll.x0 > x )
                    mouse.flags = B_HMIRROR;
                else
                    mouse.flags = 0;
                end
            elseif ( mouse.y + scroll.y0 > prota.y + 15 )
                if ( abs( mouse.x + scroll.x0 - prota.x ) > 20 )
                    mouse.graph = 997;
                else
                    mouse.graph = 2;
                end
                if ( mouse.x + scroll.x0 > x )
                    mouse.flags = B_HMIRROR;
                else
                    mouse.flags = 0;
                end
            else
                mouse.graph = 999;
            end
        end
        //col=map_get_pixel(level, 1, x, y);
        alpha = clamp( alpha+20, 0, 255 );
        if ( invul != 0 )
            if ( invul % 15 == 0 )
                alpha = 50;
            end
            invul--;
        end
        if ( os_id == OS_GP2X_WIZ )
            mouse.graph = 0;
        end
        if ( map_get_pixel( level, 1, x, y ) == pincha )
            if ( invul == 0 and est != dano and est != muerto )
                est = dano;
            end
        end
        if (( coli = collision( type rayo )) or( coli = collision( type rayo3 )))
            if ( coli.est == 1 and invul == 0 and est != dano and est != muerto )
                est = dano;
            end
        end
        if ( coli = collision( type misil ))
            if ( coli.est == 1 and invul == 0 and est != dano and est != muerto )
                coli.est = 0;
                est = dano;
            end
        end
        xx = map_get_pixel( level, 1, x, y );
        repeat
            frame;
        until ( pausa == 0 )
        if ( map_get_pixel( level, 1, x, y ) == salida and( est == pie or est == walking ))
            fin = 1;
        end
    until ( fin == 1 )
    if ( os_id != OS_GP2X_WIZ )
        mouse.graph = 999;
    end
    if ( vidas == -1 )
        monomuerte( x, y, direc );
    else
        stageclear();
    end
    //let_me_alone();
    loop
        frame;
    end
end


process monomuerte( double x, y, int dire )
    private
        double vx, vy;
begin
    ctype = c_scroll;
    cnumber = c_0;
    //file = monofpg;
    asignapal();
    graph = 2;
    flags = father.flags;
    graph = 39;

    dire = dire / 10;
    vx = 2 * dire;
    vy = 10;
    repeat
        angle += 4000 * dire;
        subest++;
        x += vx;
        y -= vy;
        if ( subest == 2 )
            subest = 0;
            vy--;
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( region_out( id, 0 ))
    gover();
end


process perfecto()
begin
    frame(0);
    file = gfpg;
    x = 249;
    y = 138;
    z = -100;
    loop
        graph = 9;
        paralo( 600 );
        graph = 0;
        paralo( 600 );
    end
end


process bmenu( double x, y )
begin
    file = gfpg;
    graph = 7;
    alpha = 0;
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    loop
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                stageid.est = 0;
                finfase = 1;
            end
        end
        frame;
    end
end


process stageclear()
begin
    x = resx / 2;
    y = resy / 2;
    file = gfpg;
    graph = 5;
    if ( music_is_playing())
        music_fade_off( 5000 );
    end
    size_y = 20;
    paralo( 200 );
    size_y = 150;
    size_x = 50;
    paralo( 200 );
    size_y = 50;
    size_x = 100;
    paralo( 200 );
    size_y = 100;
    size_x = 100;
    repeat
        subest++;
        if ( rand( 0, 4 ) == 4 )
            flags = B_TRANSLUCENT;
        else
            flags = 0;
        end
        frame;
    until ( subest == 60 );
    flags = 0;
    if ( conf.fase[ faseactual + 1 ] == 0 )
        conf.fase[ faseactual + 1 ] = 1;
    end
    if ( conf.vidafase[ faseactual + 1 ] < vidas )
        conf.vidafase[ faseactual + 1 ] = vidas;
    end
    if ( perfect )
        if ( conf.fase[ faseactual ] == 1 and faseactual != 0 )
            unlock();
        end
        conf.fase[ faseactual ] = 2;
        if ( faseactual != 0 )
            perfecto();
        end
    end
    bmenu( 126, 150 );
    bnext();
    loop
        frame;
    end
end


process unlock()
begin
    frame(0);
    file = gfpg;
    graph = 16;
    x = 160;
    y = 160;
    loop
        graph = 16;
        paralo( 600 );
        graph = 0;
        paralo( 600 );
    end
end


process bnext()
begin
    file = gfpg;
    graph = 8;
    alpha = 0;
    x = 199;
    y = 150;
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    loop
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                stageid.est = 1;
                finfase = 1;
            end
        end
        frame;
    end
end


process control()
begin
    loop
        if ( gm )
            invul = 255;
        end
        //if(key(_q)) finfase=1; end
        if ( !( jkeys_state[ _JKEY_L ] or jkeys_state[ _JKEY_R ] ))
            if ( jkeys_state[ _JKEY_A ] or jkeys_state[ _JKEY_LEFT ] or( mouse.left and( mouse.y + scroll.y0 >= prota.y -30 ) and( mouse.x + scroll.x0 < prota.x ) and( abs( mouse.x + scroll.x0 - prota.x ) > 20 )))
                left = 1;
            else
                left = 0;
            end
            if ( jkeys_state[ _JKEY_B ] or jkeys_state[ _JKEY_RIGHT ] or( mouse.left and( mouse.y + scroll.y0 >= prota.y -30 ) and( mouse.x + scroll.x0 > prota.x ) and( abs( mouse.x + scroll.x0 - prota.x ) > 20 )))
                right = 1;
            else
                right = 0;
            end
            if ( jkeys_state[ _JKEY_X ] or jkeys_state[ _JKEY_DOWN ] or( mouse.left and( mouse.y + scroll.y0 > prota.y + 15 )))
                down = 1;
            else
                down = 0;
            end
        end
        if ( jkeys_state[ _JKEY_MENU ] )
            if ( z != 1 )
                z = 1;
                if ( !get_id( type stageclear ) and !get_id( type tuto ) and !( get_id( type gover ) or finfase == 1 or fade_info.fading ))
                    if ( pausa == 0 )
                        pausa = 1;
                        pausador();
                    else
                        pausa = 0;
                    end
                end
            end
        else
            z = 0;
        end
        if ( jkeys_state[ _JKEY_SELECT ] )
            if ( est != 1 )
                est = 1;
                if ( conf.autocam == 1 )
                    conf.autocam = 0;
                else
                    conf.autocam = 1;
                end
                if ( select == 0 )
                    select = 1;
                else
                    select = 0;
                end
            end
        else
            est = select = 0;
        end
        /*if(key(_enter)) prota.est=dano;
switch (rand(0,2))
										case 0:
											sonid(cabreowav);
										end

										case 1:
											sonid(cabreowav2);
										end

										case 2:
											sonid(cabreowav3);
										end
end

end*/
        frame;
    end
end


process marca2( double x, y )
begin
    file = gfpg;
    ctype = c_scroll;
    cnumber = c_0;
    flags = B_ABLEND;
    //z=1000;
    graph = 998;
    repeat
        repeat
            frame;
        until ( pausa == 0 )
    until ( collision( prota ))
    repeat
        alpha = clamp( alpha-30, 0, 255 );
        repeat
            frame;
        until ( pausa == 0 )
    until ( alpha == 0 )
end


process dust( double x, y )
//private dir;
begin
    file = gfpg;
    ctype = father.ctype;
    cnumber = father.cnumber;
    alpha = 150;
    angle = rand( 0, 360 ) * 1000;
    graph = 15;
    size = rand( 50, 75 );
    y += rand( -20, 20 );
    z = 10;
    flags = rand( 0, 1 );
    //if(father.flags==0) dir=1; else dir=-1; end
    //x+=10*dir;
    repeat
        angle += 2000;
        alpha = clamp( alpha-6, 0, 255 );
        size += 4;
        //x+=-dir; y--;
        repeat
            frame;
        until ( pausa == 0 )
    until ( alpha < 50 )
end


process camara()
begin
    priority = -1000;
    ctype = c_scroll;
    cnumber = c_0;
    scroll.camera = id;
    if ( !get_id( type caged ))
        if ( os_id == OS_GP2X_WIZ )
            ajustascrollWIZ();
        else
            ajustascroll();
        end
    end
    loop
        /*z=rand(-5,5);
angle=rand(-5,5);
modx+=z;
mody+=angle;*/
        x = prota.x + modx;
        y = prota.y + mody;
        /*scroll.x0=x-resx/2;
scroll.y0=y-resy/2;*/
        frame;
        /*modx-=z;
mody-=angle;*/
        /*scroll.x0+=resx/2;
scroll.y0+=resy/2;*/
    end
    signal( id, s_kill_tree );
end


process ajustascroll()
//private mx,my;
begin
    file = gfpg;
    loop
        if ( get_id( type stageclear ) or get_id( type gover ))
            mouse.graph = 999;
            signal( id, s_kill );
            frame;
        end
        if ( mouse.right or (( jkeys_state[ _JKEY_L ] or jkeys_state[ _JKEY_R ] ) and mouse.left ))
            x = mouse.x;
            y = mouse.y;
            graph = 995;
            mouse.graph = 0;
            mouse.x = resx / 2;
            mouse.y = resy / 2;
            repeat
                frame;
            until ( pausa == 0 )
            repeat
                if ( get_id( type stageclear ) or get_id( type gover ))
                    mouse.graph = 999;
                    signal( id, s_kill );
                    frame;
                end
                mouse.x = resx / 2;
                mouse.y = resy / 2;
                repeat
                    frame;
                until ( pausa == 0 )
                modx -= resx / 2 - mouse.x;
                mody -= resy / 2 - mouse.y;
                //if(prota.x-scroll.x0<50) repeat modx--; frame; until(prota.x-scroll.x0==50) end
                if ( modx > 110 )
                    modx = 110;
                end
                if ( modx < -110 )
                    modx = -110;
                end
                if ( mody > 70 )
                    mody = 70;
                end
                if ( mody < -90 )
                    mody = -90;
                end
            until ( !mouse.right )
            //mouse.graph=graph;
            graph = 0;
            mouse.x = x;
            mouse.y = y;
        else
            if ( conf.autocam == 1 )
                if ( prota.est != dano )
                    if ( prota.flags == 0 )
                        if ( prota.est != walljump )
                            if ( modx < margenx )
                                modx += 5;
                            end
                        else
                            if ( modx > -margenxw )
                                modx -= 2;
                            end
                        end
                    else
                        if ( prota.est != walljump )
                            if ( modx > -margenx )
                                modx -= 5;
                            end
                        else
                            if ( modx < margenxw )
                                modx += 2;
                            end
                        end
                    end
                end
            end
        end
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process ajustascrollWIZ()
begin
    file = gfpg;
    loop
        if ( get_id( type stageclear ) or get_id( type gover ))
            signal( id, s_kill );
            frame;
        end
        if (( jkeys_state[ _JKEY_L ] or jkeys_state[ _JKEY_R ] ) and mouse.left )
            x = mouse.x;
            y = mouse.y;
            mouse.graph = 995;
            repeat
                frame;
            until ( pausa == 0 )
            repeat
                if ( get_id( type stageclear ) or get_id( type gover ))
                    signal( id, s_kill );
                    frame;
                end
                x = mouse.x;
                y = mouse.y;
                repeat
                    frame;
                until ( pausa == 0 )
                modx -= x - mouse.x;
                mody -= y - mouse.y;
                if ( modx > 110 )
                    modx = 110;
                end
                if ( modx < -110 )
                    modx = -110;
                end
                if ( mody > 70 )
                    mody = 70;
                end
                if ( mody < -90 )
                    mody = -90;
                end
            until ( !(( jkeys_state[ _JKEY_L ] or jkeys_state[ _JKEY_R ] ) and mouse.left ))
            mouse.graph = 0;
            mouse.x = x;
            mouse.y = y;
        else
            if ( conf.autocam == 1 )
                if ( prota.est != dano )
                    if ( prota.flags == 0 )
                        if ( prota.est != walljump )
                            if ( modx < margenx )
                                modx += 5;
                            end
                        else
                            if ( modx > - margenxw )
                                modx -= 2;
                            end
                        end
                    else
                        if ( prota.est != walljump )
                            if ( modx > - margenx )
                                modx -= 5;
                            end
                        else
                            if ( modx < margenxw )
                                modx += 2;
                            end
                        end
                    end
                end
            end
        end
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process sonid( int wv )
    private
        int l, r;
begin
    if ( sound_is_playing( voz ))
        sound_stop( voz );
    end
    voz = sound_play( wv, 0 );
    while ( sound_is_playing( voz ))
        if ( exists( father ))
            if (( father.x - scroll.x0 ) < 0 )
                r = 0;
            else
                r = abs((( father.x - scroll.x0 ) * 255 ) / resx );
            end
            if ( r > 255 )
                r = 255;
            end
            l = 255 - r;
            set_panning( voz, l, r );
        end
        frame;
    end
end


process sonidf( int wv )
    private
        int l, r;
begin
    z = sound_play( wv, 0 );
    while ( sound_is_playing( z ))
        if ( exists( father ))
            if (( father.x - scroll.x0 ) < 0 )
                r = 0;
            else
                r = abs((( father.x - scroll.x0 ) * 255 ) / resx );
            end
            if ( r > 255 )
                r = 255;
            end
            l = 255 - r;
            set_panning( z, l, r );
        end
        //if(key(_enter)) sound_stop(z); end
        frame;
    end
end


process energia( z )
    private
        double vx, vy;
begin
    file = gfpg;
    graph = 1;
    x = ( 320 - z * 20 );
    y = 230;
    repeat
        if ( ener == 1 )
            size -= 2;
            if ( size <= 75 )
                size = 120;
            end
        end
        frame;
    until ( ener < z )
    vy = rand( 10, 20 );
    vx = rand( 2, 6 );
    repeat
        alpha = clamp( alpha-10, 0, 255 );
        x -= vx;
        y -= vy;
        vy--;
        angle -= 2000;
        repeat
            frame;
        until ( pausa == 0 )
    until ( alpha == 0 )
end


process vida()
begin
    //file = monofpg;
    graph = 49;
    asignapal();
    x = 20;
    y = 225;
    equis();
    numvida();
    loop
        repeat
            subest++;
            frame;
        until ( subest == 60 )
        subest = 0;
        if ( rand( 0, 2 ) == 0 )
            graph = 50;
            frame;
            graph = 51;
            paralo( 300 );
            graph = 49;
        end
    end
end


process equis()
begin
    file = gfpg;
    graph = 14;
    x = 42;
    y = 227;
    loop
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process numvida()
    private
        int pregr;
begin
    file = gfpg;
    x = 60;
    y = 225;
    loop
        graph = 10 + vidas;
        if ( graph < 10 )
            graph = 10;
        end
        if ( graph != pregr )
            numvidafuera( pregr );
        end
        repeat
            frame;
        until ( pausa == 0 )
        pregr = graph;
    end
end


process numvidafuera( graph )
    private
        double vx, vy;
begin
    file = gfpg;
    x = 60;
    y = 225;
    vy = rand( 10, 20 );
    vx = rand( 2, 6 );
    repeat
        x += vx;
        y -= vy;
        vy--;
        angle += 2000;
        frame;
    until ( region_out( id, 0 ))
end


process reflejo()
begin
    ctype = c_scroll;
    cnumber = c_1;
    z = 600;
    file = levelm;
    graph = 5;
    flags = B_ABLEND;
    //alpha=100;
    loop
        x = scroll[ 1 ].x0 + 160;
        y = scroll[ 1 ].y0 + 120;
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process reflejob()
begin
    ctype = c_scroll;
    cnumber = c_0;
    z = 600;
    file = levelm;
    graph = 5;
    //flags=B_TRANSLUCENT;
    alpha = 100;
    loop
        x = scroll.x0 + 160;
        y = scroll.y0 + 120;
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process caged( double x, y )
    private
        double vx, vy, fx, fy;
        int fyint, fxint, direc, alarido, c;
        byte i, t, preest, mbf, obst, sal, l, r, ya, invul;
begin
    modx = 130;
    mouse.graph = 0;
    frame( 0 );
    //scroll.camera=id;
    ctype = c_scroll;
    cnumber = c_0;
    //file = monofpg;
    asignapal();
    graph = 45;
    //suelo=resy-5;
    //suelo=870;
    //y=fy=suelo; x=fx=(resx/2);
    fx = x;
    fy = y;
    mouse.file = gfpg;
    //colors_get(1,15,16, &color);
    if ( os_id != OS_GP2X_WIZ )
        mouse.graph = 999;
    end
    repeat
        realx = x - scroll.x0;
        realy = y - scroll.y0;
        preest = est;
        if ( modx == 0 )
            if ( mouse.left )
                if ( mbf != 1 )
                    mbf = 1;
                    if (( est == pie or est == walking or( est == walljump and(( flags == 0 and mouse.x + scroll.x0 < x ) or( flags == B_HMIRROR and mouse.x + scroll.x0 > x )))) and mouse.y + scroll.y0 < y -30 )
                        marca( mouse.x + scroll.x0, mouse.y + scroll.y0 );
                        est = salto;
                        //			vy=1.375*(sqrt(y-(mouse.y+scroll.y0)));
                        //			vx=(((mouse.x+scroll.x0)-x)/vy);
                        //if(obst==1) graph=1; end
                        /*			switch (rand(0,1))

				case 0:
					sonid(saltowav);
				end

				case 1:
					sonid(saltowav1);
				end
			end*/
                        vy = 0.97 * ( sqrt( y - ( mouse.y + scroll.y0 )));
                        vx = ((( mouse.x + scroll.x0 ) - x ) / vy ) / 2;
                        if ( vx > 0 )
                            flags = 0;
                        elseif ( vx < 0 )
                            flags = B_HMIRROR;
                        end
                    end
                end
            else
                mbf = 0;
            end
        end
        if ( vx > clim )
            vx = clim;
        end
        if ( vx < - clim )
            vx = - clim;
        end
        if ( vy > clim )
            vy = clim;
        end
        fx += vx;
        fxint = fx;
        repeat
            if ( flags == 0 )
                direc = 10;
            else
                direc = -10;
            end
            //if(est==dano) direc*=-1; end
            if ( map_get_pixel( level, 1, x + direc + (( abs( vx ) / vx )), y -1 ) == pare )
                //if(est==dano) x+=(direc/-1); end
                fx = x; //vy=0; fy=y;
                //vy/=2;
                obst = 1;
                break;
            else
                obst = 0;
                /*if(graph==6 and vy<0)
					vx=0;
					if(flags==0) x-=2; fx=x; else x+=2; fx=x; end
					x=fxint;
				end*/
            end
            if ( x < fxint )
                x++;
            end
            if ( x > fxint )
                x--;
            end
        until ( x == fxint )
        //x=fx; //y=fy;
        if ( y > 0 )
        end
        //if(y>suelo) vx=0; est=pie; y=suelo; fy=suelo; end
        //if(x<0) x=0; fx=0; elseif(x>resx) fx=resx; x=resx; end
        if ( preest != est )
            i = 0;
            t = 0;
        end
        switch ( est )
            case salto:
                fy -= vy;
                fyint = fy;
                repeat
                    if ( y < fyint )
                        y++;
                    end
                    if ( y > fyint )
                        y--;
                    end
                    if ( map_get_pixel( level, 1, x, y + 1 ) == chan and vy < 0 )
                        if ( vy >= -20 )
                            sonidf( jaulawav );
                        else
                            sonidf( jaulacwav );
                        end
                        if ( left )
                            est = walking;
                            vx = - wlkspd;
                        end
                        if ( right )
                            est = walking;
                            vx = wlkspd;
                        end
                        est = pie;
                        if ( vy < -20 )
                            sal = 1;
                            subest = ater;
                        end
                        vx = 0;
                        vy = 0;
                        fy = y;
                        break;
                    elseif ( map_get_pixel( level, 1, x, y -10 ) == techo and vy > 0 )
                        sonidf( techowav );
                        vy = -1;
                        fy = y;
                        break;
                    end
                until ( y == fyint )
                vy -= 0.5;
                angle -= 500;
                /*if(vy<0 and obst==1) vy-=0.05;
			else vy-=0.5;
		end*/
                /*if(obst==1)

			if(flags==0 and left) vx=0; x-=50; fx=x;
			elseif(flags==B_HMIRROR and right) vx=0; x+=50; fx=x;
			else
			graph=6; if(t%2==0) dust(x,y); fx=x;
			end

			end
		end*/
            end
            case pie:
                angle = 0;
                vx = 0;
                if ( map_get_pixel( level, 1, x, y + 1 ) != chan )
                    est = salto;
                    vy = 0;
                end
                while ( map_get_pixel( level, 1, x, y ) == chan )
                    y--;
                    fy--;
                end
            end
        end
        switch ( est )
            case salto:
            end
            case pie:
            end
        end
        if ( vx > 0 )
            flags = 0;
        elseif ( vx < 0 )
            flags = B_HMIRROR;
        end
        if ( est != pie )
            subest = parao;
        end
        /*if(!mouse.right)
	if(mouse.y+scroll.y0>=prota.y-30 and (est==pie or est==walking))
		mouse.graph=996;
		if(mouse.x+scroll.x0>x) mouse.flags=B_HMIRROR; else mouse.flags=0; end
	else
		mouse.graph=999;
	end
end*/
        //col=map_get_pixel(level, 1, x, y);
        if ( c % 10 == 0 )
            if ( graph == 45 )
                graph = 48;
            else
                graph = 45;
            end
        end
        if ( !sound_is_playing( alarido ))
            switch ( rand( 0, 2 ))
                case 0:
                    alarido = sound_play( aak, 0 );
                end
                case 1:
                    alarido = sound_play( aak2, 0 );
                end
                case 2:
                    alarido = sound_play( aak3, 0 );
                end
            end
        else
            r = (( x - scroll.x0 ) * 255 ) / resx;
            l = 255 - r;
            set_panning( alarido, l, r );
        end
        c++;
        repeat
            frame;
        until ( pausa == 0 )
        if ( modx > 0 )
            if ( c > 120 )
                modx -= 2;
            end
        elseif ( ya == 0 )
            ya = 1;
            pausa = 1;
            tuto();
            if ( os_id != OS_GP2X_WIZ )
                mouse.graph = 999;
            end
        end
    until ( sal == 1 )
    prota = monete( x, y );
    graph = 0;
    ceive( 46, x, y );
    ceive( 47, x, y );
    signal( get_id( type control ), s_kill );
    repeat
        frame;
    until ( prota.est == pie )
    sonid( cabreowav2 );
    prota.subest = hoook;
    repeat
        frame;
    until ( prota.subest != hoook )
    repeat
        right = 1;
        z++;
        repeat
            frame;
        until ( pausa == 0 )
    until ( prota.x >= 186 )
    puertascensor();
    map_clear( level, 1, 158, 1650, 158, 1765, pare );
    right = 0;
    frame;
    pausa = 1;
    music_play( canc, -1 );
    tutos();
    repeat
        frame;
    until ( !get_id( type tutos ))
    pausa = 0;
    tipocam();
    control();
    if ( os_id == OS_GP2X_WIZ )
        ajustascrollWIZ();
    else
        ajustascroll();
    end
end


process tutos()
begin
    y = 120;
    file = tutofpg;
    graph = 20;
    if ( os_id != OS_GP2X_WIZ )
        mouse.graph = 999;
    end
    if ( conf.fase[ 0 ]
        == 2 ) skip();
    end
    repeat
        x = 460;
        repeat
            subest++;
            x -= subest;
            if ( x < 160 )
                x = 160;
            end
            if ( os_id == OS_GP2X_WIZ )
                graph += 10;
                frame;
                graph -= 10;
            else
                frame;
            end
        until ( x == 160 )
        repeat
            if ( os_id == OS_GP2X_WIZ )
                graph += 10;
                frame;
                graph -= 10;
            else
                frame;
            end
        until (( collision( type mouse ) and mouse.left ) or est == 1 )
        repeat
            if ( os_id == OS_GP2X_WIZ )
                graph += 10;
                frame;
                graph -= 10;
            else
                frame;
            end
        until ( !mouse.left or est == 1 )
        subest = 0;
        repeat
            subest++;
            x -= subest;
            if ( os_id == OS_GP2X_WIZ )
                graph += 10;
                frame;
                graph -= 10;
            else
                frame;
            end
        until ( x <= -160 )
        subest = 0;
        graph++;
        if ( est == 1 )
            graph = 28;
        end
    until ( graph == 28 )
    signal( id, s_kill_tree );
end


process tuto()
begin
    file = tutofpg;
    graph = 1;
    x = 460;
    y = 120;
    z = 10;
    repeat
        subest++;
        x -= subest;
        if ( x < 160 )
            x = 160;
        end
        frame;
    until ( x == 160 )
    repeat
        frame;
    until ( collision( type mouse ) and mouse.left )
    repeat
        frame;
    until ( !mouse.left )
    subest = 0;
    repeat
        subest++;
        x -= subest;
        frame;
    until ( x < -160 )
    pausa = 0; //modx=1;
end


process ceive( graph, double x, y )
    private
        double vy = 15;
begin
    ctype = c_scroll;
    cnumber = c_0;
    //file = monofpg;
    asignapal();
    repeat
        y -= vy;
        vy--;
        if ( graph == 46 )
            x -= 3;
            angle -= 500;
        else
            x += 3;
            angle += 500;
        end
        repeat
            frame;
        until ( pausa == 0 )
    until ( y > 1900 )
end


process puertascensor()
begin
    ctype = c_scroll;
    cnumber = c_0;
    file = levelm;
    graph = 6;
    x = 127;
    y = 1660;
    size_y = 0;
    repeat
        repeat
            frame;
        until ( pausa == 0 )
        size_y += 3;
    until ( size_y > 100 )
    size_y = 100;
    loop
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process elec( double x, y, size_y )
begin
    z = -10;
    ctype = c_scroll;
    cnumber = c_0;
    file = enem;
    graph = 1;
    flags = B_ABLEND;
    loop
        est++;
        if ( est == 5 )
            est = 0;
            if ( flags == B_ABLEND )
                flags = B_ABLEND | B_HMIRROR;
            else
                flags = B_ABLEND;
            end
        end
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process intro()
begin
    file = intro_fpg;
    //mouse.file=file; mouse.flags=B_TRANSLUCENT; mouse.graph=21;
    put_screen( file, 20 );
    graph = 19;
    x = 160;
    y = 240;
    repeat
        est++;
        if ( est % 5 == 0 )
            y++;
        end
        frame;
    until ( y == 320 )
    est = 0;
    paralo( 2000 );
    ventan();
    repeat
        frame;
    until ( !get_id( type ventan ))
    put_screen( file, 4 );
    graph = 5;
    x = 653;
    y = 240;
    repeat
        x -= est / 4;
        est++;
        if ( x < 178 )
            x = 178;
        end
        frame;
    until ( x == 178 )
    graph = 0;
    put_screen( file, 6 );
    paralo( 10000 );
    graph = 11;
    x = -160;
    y = 120;
    est = 0;
    repeat
        x += est / 4;
        est++;
        if ( x > 160 )
            x = 160;
        end
        frame;
    until ( x == 160 )
    graph = 0;
    put_screen( file, 11 );
    sound_play( saltowav, 0 );
    paralo( 10000 );
    est = 0;
    graph = 1;
    x = 160;
    y = 120;

    map_clear(0, background.graph, rgb( 8, 24, 24 ));

    mico();
    loop
        est++;
        if ( est == 1 )
            est = 0;
            size += 2;
        end
        frame;
    end
end


process ventan()
begin
    file = intro_fpg;
    graph = 21;
    x = 195;
    y = 97;
    alpha = 0;
    z = -1000;
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    paralo( 10000 );
end


process mico()
    private
        int tm, so;
begin
    file = intro_fpg;
    graph = 1;
    x = 160;
    y = 120;
    graph = 2;
    size = 50;
    so = sound_play( cla, -1 );
    repeat
        est++;
        if ( est == 3 )
            est = 0;
            if ( graph == 2 )
                graph = 3;
            else
                graph = 2;
            end
        end
        z++;
        if ( z == 4 )
            z = 0;
            if ( size < 100 )
                size += 1;
            end
        end
        if ( size > 60 )
            father.alpha = clamp( father.alpha-10, 0, 255 );
        end
        if ( size == 100 )
            tm++;
        end
        if ( z % 2 == 0 )
            x += 2;
        else
            x -= 2;
        end
        frame;
    until ( tm == 120 );
    signal( father, s_kill );
    sound_stop( so );
    belfo();
end


process belfo()
begin
    file = intro_fpg;
    put_screen( file, 6 );
    graph = 7;
    x = 235;
    y = 103;
    alpha = 0;
    repeat
        est++;
        frame;
    until ( est == 60 );
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    jering();
    repeat
        frame;
    until ( est == 0 );
end


process flare( double x, y )
begin
    file = intro_fpg;
    graph = 10;
    flags = B_ABLEND;
    z = -10;
    size = 25;
    repeat
        size += 5;
        angle += 20000;
        frame;
    until ( size > 100 )
    repeat
        angle += 20000;
        frame;
        size -= 5;
    until ( size < 0 )
end


process jering()
begin
    file = intro_fpg;
    graph = 8;
    x = 247;
    y = 300;
    repeat
        y -= est / 8;
        est++;
        if ( y < 239 )
            y = 239;
        end
        frame;
    until ( y == 239 )
    put_screen( file, 12 );
    graph = 0;
    father.est = 0;
    flare( 201, 95 );
    repeat
        frame;
    until ( !get_id( type flare ))
    flare( 147, 161 );
    paralo( 10000 );
    graph = 15;
    x = 160;
    y = 360;
    est = 0;
    repeat
        y -= est / 8;
        est++;
        if ( y < 120 )
            y = 120;
        end
        frame;
    until ( y == 120 )
    put_screen( file, graph );
    graph = 0;
    paralo( 5000 );
    put_screen( file, 14 );
    dodot();
end


process dodot()
begin
    file = intro_fpg;
    graph = 13;
    x = 138;
    y = 117;
    est = sound_play( aak2, 0 );
    set_panning( est, 255, 0 );
    est = 0;
    repeat
        xadvance( 20000, 10 );
        frame;
    until ( x > 660 )
    graph = 0;
    paralo( 1000 );
    put_screen( file, 16 );
    jeri2();
    sound_play( prrz, 0 );
    x = 150;
    y = 240;
    graph = 18;
    repeat
        y += est / 20;
        est++;
        if ( y > 310 )
            y = 310;
        end
        frame;
    until ( y == 310 )
    est = 0;
    sound_play( cabe, 0 );
    repeat
        est++;
        x++;
        frame;
        x--;
        frame;
    until ( est == 30 )
    est = 0;
    repeat
        y += est / 15;
        est++;
        if ( y > 540 )
            y = 540;
        end
        frame;
    until ( y == 540 )
    prota.est = 1;
end


process jeri2()
begin
    x = 103;
    y = 143;
    file = intro_fpg;
    graph = 17;
    z = -100;
    repeat
        y -= 10;
        angle -= 10000;
        frame;
    until ( y < -50 )
end


process estr( double x, y, int graph, dir )
begin
    ctype = c_scroll;
    cnumber = c_0;
    file = levelm;
    angle = rand( 0, 360 ) * 1000;
    loop
        angle += 15000 * dir;
        repeat
            frame;
        until ( pausa == 0 )
    end
end

/*IF (GET_JOY_BUTTON(0,_JKEY_VOLDOWN)==1)
   set_channel_volume(-1,SFX_VOL-=1);
   set_song_volume(MUS_VOL-=1);
   IF(SFX_VOL<0) SFX_VOL=0; END
   IF(MUS_VOL<0) MUS_VOL=0; END
END*/

process rayo( double x, y, int angle, timing )
begin
    file = rayofpg;
    ctype = c_scroll;
    cnumber = c_0;
    graph = 1;
    if ( timing )
        repeat
            subest++;
            repeat
                frame;
            until ( pausa == 0 )
        until ( subest == 106 )
    end
    subest = 0;
    loop
        repeat
            subest++;
            repeat
                frame;
            until ( pausa == 0 )
        until ( subest == 90 )
        subest = 0;
        repeat
            subest++;
            graph = 2;
            repeat
                frame;
            until ( pausa == 0 )
            graph = 1;
            repeat
                frame;
            until ( pausa == 0 )
        until ( subest == 14 )
        subest = 0;
        graph = 3;
        repeat
            frame;
        until ( pausa == 0 )
        graph = 4;
        repeat
            frame;
        until ( pausa == 0 )
        est = 1;
        repeat
            subest++;
            graph = 5;
            repeat
                frame;
            until ( pausa == 0 )
            graph = 6;
            repeat
                frame;
            until ( pausa == 0 )
        until ( subest == 52 )
        subest = 0;
        est = 0;
        graph = 4;
        repeat
            frame;
        until ( pausa == 0 )
        graph = 3;
        repeat
            frame;
        until ( pausa == 0 )
        subest = 0;
        graph = 1;
    end
end


process rayo3( double x, y, int angle, byte timing )
begin
    file = rayofpg;
    ctype = c_scroll;
    cnumber = c_0;
    graph = 1;
    if ( timing == 0 )
        subest = 60;
        loop
            repeat
                subest++;
                repeat
                    frame;
                until ( pausa == 0 )
            until ( subest == 120 )
            //if(timing==1) subest=0; timing=0; else subest
            subest = 0;
            repeat
                subest++;
                graph = 2;
                repeat
                    frame;
                until ( pausa == 0 )
                graph = 1;
                repeat
                    frame;
                until ( pausa == 0 )
            until ( subest == 30 )
            subest = 0;
            graph = 3;
            repeat
                frame;
            until ( pausa == 0 )
            graph = 4;
            repeat
                frame;
            until ( pausa == 0 )
            est = 1;
            repeat
                subest++;
                graph = 5;
                repeat
                    frame;
                until ( pausa == 0 )
                graph = 6;
                repeat
                    frame;
                until ( pausa == 0 )
            until ( subest == 28 )
            subest = 0;
            est = 0;
            graph = 4;
            repeat
                frame;
            until ( pausa == 0 )
            graph = 3;
            repeat
                frame;
            until ( pausa == 0 )
            subest = 0;
            graph = 1;
        end
    else
        loop
            est = 1;
            repeat
                subest++;
                graph = 5;
                repeat
                    frame;
                until ( pausa == 0 )
                graph = 6;
                repeat
                    frame;
                until ( pausa == 0 )
            until ( subest == 28 )
            subest = 0;
            est = 0;
            graph = 4;
            repeat
                frame;
            until ( pausa == 0 )
            graph = 3;
            repeat
                frame;
            until ( pausa == 0 )
            subest = 0;
            graph = 1;
            repeat
                subest++;
                repeat
                    frame;
                until ( pausa == 0 )
            until ( subest == 120 )
            subest = 0;
            repeat
                subest++;
                graph = 2;
                repeat
                    frame;
                until ( pausa == 0 )
                graph = 1;
                repeat
                    frame;
                until ( pausa == 0 )
            until ( subest == 30 )
            subest = 0;
            graph = 3;
            repeat
                frame;
            until ( pausa == 0 )
            graph = 4;
            repeat
                frame;
            until ( pausa == 0 )
        end
    end
end


process plat( double x, y, int est )
begin
    file = platfpg;
    ctype = c_scroll;
    z = 100;
    cnumber = c_0;
    map_clear( level, 1, x -46, y, x + 46, y, chan );
    graph = 1;
    if ( est )
        repeat
            subest++;
            repeat
                frame;
            until ( pausa == 0 )
        until ( subest == tplat + 30 )
    end
    subest = 0;
    loop
        map_clear( level, 1, x -46, y, x + 46, y, chan );
        graph = 1;
        repeat
            repeat
                frame;
            until ( pausa == 0 )
            subest++;
        until ( subest == tplat )
        subest = 0;
        repeat
            graph = 6;
            repeat
                frame;
            until ( pausa == 0 )
            repeat
                frame;
            until ( pausa == 0 )
            graph = 1;
            repeat
                frame;
            until ( pausa == 0 )
            repeat
                frame;
            until ( pausa == 0 )
            subest++;
        until ( subest == 15 )
        map_clear( level, 1, x -46, y, x + 46, y );
        graph = 2;
        repeat
            frame;
        until ( pausa == 0 )
        graph = 3;
        repeat
            frame;
        until ( pausa == 0 )
        graph = 4;
        repeat
            frame;
        until ( pausa == 0 )
        graph = 5;
        repeat
            repeat
                frame;
            until ( pausa == 0 )
            subest++;
        until ( subest == tplatd )
        subest = 0;
    end
end


process menmonete( double x, y )
    private
        double vx, vy, fx, fy;
        int fyint, fxint, direc, coli;
        byte walk[] = 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 3, 3, 3, 3, 2, 2, 2, 2;
        byte cabreo[] = 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10;
        byte saltos[] = 33, 34, 35, 36, 37, 38, 37, 36, 35, 34;
        byte ate[] = 32, 32, 32, 31, 31, 30;
        byte i, t, preest, mbf = 1, c, cabr, obst, invul;
begin
    frame( 0 );
//    file = monofpg;
    graph = 2;
    z = -100;
    fx = x;
    fy = y;
    est = salto;
    obst = 0;
    loop
        preest = est;
        /*if(mouse.right)
switch (rand(0,9))
case 0: palette=p0; end
case 1: palette=p1; end
case 2: palette=p2; end
case 3: palette=p3; end
case 4: palette=p4; end
case 5: palette=p5; end
case 6: palette=p6; end
case 7: palette=p7; end
case 8: palette=p8; end
case 9: palette=p9; end
end

end*/
        asignapal();
        if ( mouse.left )
            if ( mbf != 1 )
                mbf = 1;
                if (( est == pie or est == walking or( est == walljump and(( flags == 0 and mouse.x + scroll.x0 < x ) or( flags == B_HMIRROR and mouse.x + scroll.x0 > x )))) and mouse.y + scroll.y0 < y -30 )
                    marca( mouse.x + scroll.x0, mouse.y + scroll.y0 );
                    est = salto;
                    //			vy=1.375*(sqrt(y-(mouse.y+scroll.y0)));
                    //			vx=(((mouse.x+scroll.x0)-x)/vy);
                    //if(obst==1) graph=1; end
                    if ( conf.grav == 0 )
                        vy = 0.97 * ( sqrt( y - ( mouse.y + scroll.y0 )));
                        vx = ((( mouse.x + scroll.x0 ) - x ) / vy ) / 2;
                    else
                        vy = 1.375 * ( sqrt( y - ( mouse.y + scroll.y0 )));
                        vx = ((( mouse.x + scroll.x0 ) - x ) / vy );
                    end
                    if ( vx > 0 )
                        flags = 0;
                    elseif ( vx < 0 )
                        flags = B_HMIRROR;
                    end
                end
            end
        else
            mbf = 0;
        end
        fx += vx;
        fxint = fx;
        repeat
            if ( flags == 0 )
                direc = 10;
            else
                direc = -10;
            end
            //if(est==dano) direc*=-1; end
            if ( map_get_pixel( prota.file, 998, x + direc + (( abs( vx ) / vx )), y -1 ) == pare )
                //if(est==dano) x+=(direc/-1); end
                fx = x; //vy=0; fy=y;
                //vy/=2;
                obst = 1;
                break;
            else
                obst = 0;
                /*if(graph==6 and vy<0)
					vx=0;
					if(flags==0) x-=2; fx=x; else x+=2; fx=x; end
					x=fxint;
				end*/
            end
            if ( x < fxint )
                x++;
            end
            if ( x > fxint )
                x--;
            end
        until ( x == fxint )
        //x=fx; //y=fy;
        if ( y > 0 )
        end
        //if(y>suelo) vx=0; est=pie; y=suelo; fy=suelo; end
        //if(x<0) x=0; fx=0; elseif(x>resx) fx=resx; x=resx; end
        if ( preest != est )
            i = 0;
            t = 0;
        end
        switch ( est )
            case salto:
                fy -= vy;
                fyint = fy;
                repeat
                    if ( y < fyint )
                        y++;
                    end
                    if ( y > fyint )
                        y--;
                    end
                    if (( map_get_pixel( prota.file, 998, x, y + 1 ) == chan and vy < 0 ) and !( down and map_get_pixel( prota.file, 998, x, y + 2 ) != chan ))
                        if ( left )
                            est = walking;
                            vx = - wlkspd;
                        end
                        if ( right )
                            est = walking;
                            vx = wlkspd;
                        end
                        if ( !right and !left )
                            est = pie;
                            if ( vy < -10 )
                                subest = ater;
                            end
                        end
                        vx = 0;
                        vy = 0;
                        fy = y;
                        break;
                    elseif ((( map_get_pixel( prota.file, 998, x, y -10 ) == techo ) or( map_get_pixel( prota.file, 998, x + direc, y -10 ) == techo )) and vy > 0 )
                        vy = -1;
                        fy = y;
                        break;
                    end
                until ( y == fyint )
                if ( conf.grav == 0 )
                    vy -= 0.5;
                else
                    vy--;
                end
                if ( obst == 1 )
                    est = walljump;
                    t = 0;
                end
                /*if(vy<0 and obst==1) vy-=0.05;
			else vy-=0.5;
		end*/
                /*if(obst==1)

			if(flags==0 and left) vx=0; x-=50; fx=x;
			elseif(flags==B_HMIRROR and right) vx=0; x+=50; fx=x;
			else
			graph=6; if(t%2==0) dust(x,y); fx=x;
			end

			end
		end*/
            end
            case pie:
                vx = 0;
                if ( left )
                    est = walking;
                    t = 3;
                end
                if ( right )
                    est = walking;
                end
                if ( map_get_pixel( prota.file, 998, x, y + 1 ) != chan )
                    est = salto;
                    vy = 0;
                end
                while ( map_get_pixel( prota.file, 998, x, y ) == chan )
                    y--;
                    fy--;
                end
            end
            case walking:
                if ( vx => 0 and !right )
                    if ( left )
                        vx = - wlkspd;
                    else
                        est = pie;
                        vx = 0;
                    end
                end
                if ( vx =< 0 and !left )
                    if ( right )
                        vx = wlkspd;
                    else
                        est = pie;
                        vx = 0;
                    end
                end
                if ( map_get_pixel( prota.file, 998, x, y + 1 ) != chan )
                    est = salto;
                    vy = 0;
                end
                while ( map_get_pixel( prota.file, 998, x, y ) == chan )
                    y--;
                    fy--;
                end
            end
            case walljump:
                fy -= vy;
                fyint = fy;
                t++;
                repeat
                    if ( y < fyint )
                        y++;
                    end
                    if ( y > fyint )
                        y--;
                    end
                    if ( map_get_pixel( prota.file, 998, x, y + 1 ) == chan and vy < 0 )
                        vx = 0;
                        vy = 0;
                        fy = y;
                        if ( left )
                            est = walking;
                            vx = - wlkspd;
                        end
                        if ( right )
                            est = walking;
                            vx = wlkspd;
                        end
                        if ( !right and !left )
                            est = pie;
                        end
                        break;
                    elseif ( map_get_pixel( prota.file, 998, x, y -10 ) == techo and vy > 0 )
                        vy = -1;
                        fy = y;
                        break;
                    end
                until ( y == fyint )
                if ( obst == 0 )
                    est = salto;
                    if ( vy <= 0 )
                        vx = 0;
                        if ( flags == 0 )
                            x -= 10;
                            fx = x;
                        else
                            x += 10;
                            fx = x;
                        end
                    end
                end
                if ( t % 2 == 0 ) /*dust(x+direc,y);*/
                    fx = x;
                end
                if ( left and flags == 0 )
                    vx = -0.5;
                    obst = 0;
                    est = salto;
                end
                if ( right and flags == B_HMIRROR )
                    vx = 0.5;
                    obst = 0;
                    est = salto;
                end
                if ( vy > 0 )
                    if ( conf.grav == 0 )
                        vy -= 0.5;
                    else
                        vy--;
                    end
                else
                    vy -= 0.025;
                end
            end
            case dano:
                invul = 0;
                if ( graph != 39 )
                    ener--;
                    if ( flags == 0 )
                        vx = -5;
                    else
                        vx = 5;
                    end
                    vy = 7;
                end
                graph = 39;
                fy -= vy;
                fyint = fy;
                repeat
                    if ( y < fyint )
                        y++;
                    end
                    if ( y > fyint )
                        y--;
                    end
                    if ( map_get_pixel( prota.file, 998, x, y + 1 ) == chan and vy < 0 )
                        invul = 255;
                        //if(obst==1)x+=(direc/-1)/2; fx=x; end
                        if ( left )
                            est = walking;
                            vx = - wlkspd;
                        end
                        if ( right )
                            est = walking;
                            vx = wlkspd;
                        end
                        if ( !right and !left )
                            est = pie;
                            subest = hoook;
                            if ( flags == 0 )
                                flags = B_HMIRROR;
                            else
                                flags = 0;
                            end
                            /*switch (rand(0,2))
										case 0:
											sonid(cabreowav);
										end

										case 1:
											sonid(cabreowav2);
										end

										case 2:
											sonid(cabreowav3);
										end
						end*/
                            /*if(vy<-10) subest=ater; end*/
                        end
                        vx = 0;
                        vy = 0;
                        fy = y;
                        break;
                    elseif ( map_get_pixel( prota.file, 998, x, y -10 ) == techo and vy > 0 )
                        vy = -1;
                        fy = y;
                        break;
                    end
                until ( y == fyint )
                vy -= 0.5;
                //if(obst==1) est=walljump; t=0; end
            end
        end
        if ( down and( est == pie or est == walking ))
            if ( map_get_pixel( prota.file, 998, x, y + 2 ) != chan )
                est = salto;
                if ( left )
                    vx = - wlkspd;
                elseif ( right )
                    vx = wlkspd;
                end
            end
        end
        switch ( est )
            case salto:
                /*t++;
		//if(preest!=salto) t=4; end
		if(t%4==0) t=0;
			graph=walk[i]; i++;
			if(i+1>sizeof(walk)) i=0; end
		end*/
                fyint = vy;
                if ( vx < 3 and vx > -3 )
                    if ( fyint > 0 )
                        graph = 14;
                    end
                    if ( fyint == 0 )
                        graph = 15;
                    end
                    if ( fyint < 0 and fyint >= -2 )
                        graph = 16;
                    end
                    if ( fyint <= -4 )
                        graph = 17;
                    end
                else
                    if ( fyint > 0 )
                        graph = 18;
                    end
                    if ( fyint == 0 )
                        graph = 19;
                    end
                    if ( fyint < 0 and fyint >= -2 )
                        graph = 20;
                    end
                    if ( fyint <= -4 )
                        graph = 21;
                    end
                end
            end
            case pie:
                switch ( subest )
                    case hoook:
                        //t++;
                        graph = cabreo[ i ];
                        i++;
                        cabr++;
                        if ( i + 1 > sizeof( cabreo ))
                            i = 0;
                        end
                        if ( cabr == 125 )
                            cabr = 0;
                            subest = parao;
                            t = 0;
                        end
                    end
                    case parao:
                        graph = 12;
                        t++;
                        i = 0;
                        if ( t == 60 )
                            switch ( rand( 0, 4 ))
                                case 0:
                                    subest = miraiz;
                                    t = 0;
                                end
                                case 1:
                                    subest = mirader;
                                    t = 0;
                                end
                                case 2:
                                    subest = mirarr;
                                    t = 0;
                                end
                                case 3:
                                    subest = parpa;
                                    t = 0;
                                end
                                case 4:
                                    if ( rand( 0, 2 ) == 2 )
                                        subest = hoook;
                                    else
                                        t = 0;
                                    end
                                end
                                case 5:
                                    subest = uhuh;
                                    t = 0;
                                end
                            end
                        end
                    end
                    case ater:
                        graph = ate[ t ];
                        t++;
                        if ( t + 1 > sizeof( ate ))
                            subest = parao;
                            t = 0;
                        end
                    end
                    case miraiz:
                        if ( t == 0 )
                            graph = 22;
                        else
                            graph = 23;
                        end
                        t++;
                        if ( t == 60 )
                            subest = parao;
                            t = 54;
                        end
                    end
                    case mirader:
                        if ( t == 0 )
                            graph = 24;
                        else
                            graph = 25;
                        end
                        t++;
                        if ( t == 60 )
                            subest = parao;
                            t = 54;
                        end
                    end
                    case mirarr:
                        if ( t == 0 )
                            graph = 29;
                        else
                            graph = 28;
                        end
                        t++;
                        if ( t == 60 )
                            subest = parao;
                            t = 54;
                        end
                    end
                    case parpa:
                        if ( t < 2 or t > 3 )
                            graph = 26;
                        else
                            graph = 27;
                        end
                        if ( t == 4 )
                            subest = parao;
                            t = 0;
                        end
                        t++;
                    end
                    case uhuh:
                        graph = saltos[ i ];
                        if ( t % 2 == 0 )
                            i++;
                            if ( i + 1 > sizeof( saltos ))
                                i = 0;
                            end
                        end
                        t++;
                        //if(t==60) t=0; i=0; subest=parao; end
                        if ( !sound_is_playing( voz ))
                            subest = parao;
                            t = 0;
                        end
                    end
                end
            end
            case walking:
                /*t++;
		if(preest!=walking) t=4; end*/
                //if(t==4) t=0;
                graph = walk[ i ];
                i++;
                if ( i + 1 > sizeof( walk ))
                    i = 0;
                end
                if ( obst == 1 )
                    graph += 39;
                end
                //end
            end
            case walljump:
                graph = 6;
                t++;
            end
        end
        if ( vx > 0 )
            flags = 0;
        elseif ( vx < 0 )
            flags = B_HMIRROR;
        end
        if ( est != pie )
            subest = parao;
        end
        //col=map_get_pixel(level, 1, x, y);
        alpha = clamp( alpha+20, 0, 255 );
        x--;
        frame;
        x++;
    end
    //let_me_alone();
end


process tipocam()
begin
    file = gfpg;
    if ( conf.autocam == 0 )
        graph = 4;
    else
        graph = 3;
    end
    y = -1;
    x = 0;
    loop
        repeat
            if ( conf.autocam == 0 )
                graph = 4;
            else
                graph = 3;
            end
            frame;
        until ( select == 1 )
        select = 0;
        repeat
            y++;
            if ( conf.autocam == 0 )
                graph = 4;
            else
                graph = 3;
            end
            frame;
        until ( y == 31 )
        repeat
            subest++;
            if ( conf.autocam == 0 )
                graph = 4;
            else
                graph = 3;
            end
            if ( select )
                subest = 0;
            end
            frame;
        until ( subest == 60 )
        subest = 0;
        repeat
            y--;
            if ( conf.autocam == 0 )
                graph = 4;
            else
                graph = 3;
            end
            frame;
        until ( y == -1 )
    end
end


function asignapal()
begin
    switch ( conf.color )
        case 0:
            father.file = p0;
        end
        case 1:
            father.file = p1;
        end
        case 2:
            father.file = p2;
        end
        case 3:
            father.file = p3;
        end
        case 4:
            father.file = p4;
        end
        case 5:
            father.file = p5;
        end
        case 6:
            father.file = p6;
        end
        case 7:
            father.file = p7;
        end
        case 8:
            father.file = p8;
        end
        case 9:
            father.file = p9;
        end
    end
end


process bcontinue( double x, y )
begin
    file = gfpg;
    graph = 6;
    alpha = 0;
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    loop
        if ( collision( type mouse ) and mouse.left )
            repeat
                frame;
            until ( !mouse.left )
            if ( collision( type mouse ))
                pausa = 0;
            end
        end
        frame;
    end
end


process pausador()
begin
    file = gfpg;
    if ( os_id != OS_GP2X_WIZ )
        mouse.graph = 999;
    end
    if ( music_is_playing())
        music_pause();
    end
    sound_play( pausaw1, 0 );
    graph = 17;
    x = 160;
    y = 120;
    bmenu( 160, 160 );
    bcontinue( 160, 145 );
    alpha = 0;
    repeat
        alpha = clamp( alpha+10, 0, 255 );
        frame;
    until ( alpha == 255 )
    repeat
        frame;
    until ( pausa != 1 )
    sound_play( pausaw2, 0 );
    music_resume();
    signal( id, s_kill_tree );
end


process gover()
    private
        double vy;
begin
    file = gfpg;
    graph = 19;
    x = 160;
    y = -32;
    z = -10;
    repeat
        subest++;
        if ( subest == 5 )
            subest = 0;
            vy++;
        end
        y += vy;
        if ( y > 120 )
            y = 120;
        end
        frame;
    until ( y == 120 )
    vy = -6;
    sound_play( boing, 0 );
    repeat
        subest++;
        if ( subest == 5 )
            subest = 0;
            vy++;
        end
        y += vy;
        if ( y > 120 )
            y = 120;
        end
        frame;
    until ( y == 120 )
    vy = -5;
    sound_play( boing, 0 );
    repeat
        subest++;
        if ( subest == 5 )
            subest = 0;
            vy++;
        end
        y += vy;
        if ( y > 120 )
            y = 120;
        end
        frame;
    until ( y == 120 )
    vy = -2;
    sound_play( boing, 0 );
    repeat
        subest++;
        if ( subest == 5 )
            subest = 0;
            vy++;
        end
        y += vy;
        if ( y > 120 )
            y = 120;
        end
        frame;
    until ( y == 120 )
    vy = -1;
    sound_play( boing, 0 );
    repeat
        subest++;
        if ( subest == 5 )
            subest = 0;
            vy++;
        end
        y += vy;
        if ( y > 120 )
            y = 120;
        end
        frame;
    until ( y == 120 )
    paralo( 5000 );
    sound_play( ooh, 0 );
    bmenu( 160, 150 );
    loop
        frame;
    end
end


process torr( double x, y, int flags, graph, alt )
begin
    file = misfpg;
    ctype = c_scroll;
    cnumber = c_0;
    canon( alt );
    z = 10;
    loop
        frame;
    end
end


process canon( alt )
    private
        double mx, my;
        int ang;
begin
    file = misfpg;
    graph = 1;
    ctype = c_scroll;
    cnumber = c_0;
    graph = 2;
    x = father.x;
    y = father.y;
    z = 11;
    loop
        ang = get_angle( prota );
        if ( ang < 0 )
            ang += 360000;
        end
        if ( father.flags != B_HMIRROR and father.flags != ( B_HMIRROR | B_VMIRROR ) )
            if (( ang <= 90000 and ang >= 0 ) or( ang >= 270000 and ang <= 360000 ))
                angle = ang;
            end
        else
            if ( ang >= 90000 and ang <= 270000 )
                angle = ang;
            end
        end
        if ( !exists( son ) and abs( prota.x - x ) < 320 and abs( prota.y - y ) < 240 and angle == ang )
            //if(!exists(son) and angle==ang)
            get_real_point( 1, offset mx, offset my );
            if ( alt )
                if ( prota.y >= y -14 )
                    misil( mx, my, angle );
                end
            else
                if ( prota.y <= y )
                    misil( mx, my, angle );
                end
            end
            /*misil(mx,my,angle-90000);
	misil(mx,my,angle+90000);*/
        end
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process cola()
begin
    resolution = father.resolution;
    file = misfpg;
    ctype = c_scroll;
    cnumber = c_0;
    graph = 4;
    flags = B_ABLEND;
    z = 14;
    loop
        if ( exists( father ))
            x = father.x;
            y = father.y;
            angle = father.angle;
        end
        //if(size==100) size=80; else size=100; end
        if ( size == 150 )
            subest = 0;
        elseif ( size == 100 )
            subest = 1;
        end
        if ( subest )
            size += 5;
        else
            size -= 5;
        end
        repeat
            frame;
        until ( pausa == 0 )
    end
end


process dust2( double x, y )
begin
    resolution = father.resolution;
    file = gfpg;
    ctype = father.ctype;
    cnumber = father.cnumber;
    //alpha=253;
    angle = rand( 0, 360 ) * 1000;
    graph = 15;
    size = rand( 50, 75 );
    //y+=rand(-20,20);
    z = -10;
    flags = rand( 0, 1 );
    repeat
        angle += 2000;
        alpha = clamp(alpha-6, 0, 255);
        size += 5;
        //x+=-dir; y--;
        repeat
            frame;
        until ( pausa == 0 )
    until ( alpha < 50 )
end


process dust3( double x, y )
begin
    resolution = father.resolution;
    file = gfpg;
    ctype = c_scroll;
    cnumber = c_0;
    //alpha=253;
    angle = rand( 0, 360 ) * 1000;
    graph = 15;
    size = rand( 100, 150 );
    //y+=rand(-20,20);
    z = -10;
    flags = rand( 0, 1 );
    repeat
        angle += 2000;
        alpha = clamp( alpha-6, 0, 255 );
        size += 5;
        y -= resolution * 3;
        repeat
            frame;
        until ( pausa == 0 )
    until ( alpha < 50 )
end


process puerta( double x, y )
    private
        int coli;
        double vy = 10;
begin
    file = levelm;
    ctype = c_scroll;
    cnumber = c_0;
    z = 100;
    graph = 2;
    repeat
        repeat
            frame;
        until ( pausa == 0 )
    until ( coli = collision( type misil ))
    coli.est = 0;
    map_clear( level, 1, x, y, x, y + 70 );
    repeat
        angle += 1000;
        y -= vy;
        vy -= 0.5;
        repeat
            frame;
        until ( pausa == 0 )
    until ( region_out( id, 0 ) and vy < -10 )
end


function paralo( z )
begin
    z = z / 100;
    //signal(father,s_freeze);
    repeat
        frame;
        z--;
    until ( z == 0 )
    //signal(father,s_wakeup);
end


process stage( est )
begin
    save( get_pref_path("bennugd.org","eeeek") + "profile.dat", conf );
    pausa = 0;
    finfase = 0;
    invul = 0;
    vidas = conf.vidafase[ faseactual ];
    clear_screen();
    modx = 0;
    mody = -65;
    switch ( est )
        case 0:
            aak3 = sound_load( "./data/aak.wav" );
            prota = id;
            intro_fpg = fpg_load( "./data/intro.fpg" );
            canc = sound_load( "./data/intro.wav" );
            cabe = sound_load( "./data/cabe.wav" );
            cla = sound_load( "./data/cla.wav" );
            prrz = sound_load( "./data/prrz.wav" );
            voz = sound_play( canc, -1 );
            intro();
            if ( conf.fase[ 0 ]
                == 2 )
                skip();
                if ( os_id != OS_GP2X_WIZ )
                    mouse.file = gfpg;
                    mouse.graph = 999;
                end
            end
            repeat
                frame;
            until ( est == 1 )
            est = 0;
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            sound_stop( voz );
            fpg_unload( intro_fpg );
            sound_unload( canc );
            sound_unload( cabe );
            sound_unload( cla );
            level = fpg_load( "./data/level08b.fpg" );
            levelm = fpg_load( "./data/level0.fpg" );
            tutofpg = fpg_load( "./data/tutos.fpg" );
            jaulawav = sound_load( "./data/metal.wav" );
            jaulacwav = sound_load( "./data/crash.wav" );
            canc = music_load( "./data/jungle-fun.ogg" );
            scroll_start( 0, levelm, 3, 0, 0, 4 );
            scroll[ 1 ].z = 1000;
            scroll[ 1 ].follow = 0;
            control();
            chan = map_get_pixel( level, 997, 0, 0 );
            pare = map_get_pixel( level, 997, 1, 0 );
            techo = map_get_pixel( level, 997, 2, 0 );
            pincha = map_get_pixel( level, 997, 3, 0 );
            salida = map_get_pixel( level, 997, 4, 0 );
            prota = caged( 432, 204 );
            //prota=monete(432,204);
            /*		enem=fpg_load("./data/enem.fpg");
		elec(208,168,173);
		elec(143,243,100);*/
            estr( 645, 217, 10, 1 );
            estr( 655, 206, 11, -1 );
            estr( 663, 223, 12, 1 );
            estr( 680, 222, 13, -1 );
            ener = 3;
            energia( 1 );
            energia( 2 );
            energia( 3 );
            vida();
            camara();
            repeat
                frame;
            until ( finfase == 1 )
            fade_off( 500 );
            paralo( 5000 );
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            scroll_stop( 0 );
            fpg_unload( level );
            fpg_unload( levelm );
            fpg_unload( tutofpg );
            sound_unload( jaulawav );
            sound_unload( jaulacwav );
            sound_unload( aak3 );
            music_unload( canc );
            fade_on( 500 );
        end
        case 2:
            level = fpg_load( "./data/level18b.fpg" );
            levelm = fpg_load( "./data/level1.fpg" );
            rayofpg = fpg_load( "./data/rayo.fpg" );
            platfpg = fpg_load( "./data/plat.fpg" );
            canc = music_load( "./data/jungle-fun.ogg" );
            scroll_start( 0, levelm, 3, 0, 0, 4 );
            /*scroll_start(1, levelm, 4, 0, 0, 4);
		scroll[1].z=1000;
		scroll[1].follow=0;
		reflejo();*/
            go(); //control();
            chan = map_get_pixel( level, 997, 0, 0 );
            pare = map_get_pixel( level, 997, 1, 0 );
            techo = map_get_pixel( level, 997, 2, 0 );
            pincha = map_get_pixel( level, 997, 3, 0 );
            salida = map_get_pixel( level, 997, 4, 0 );
            prota = monete( 75, 169 );
            tipocam();
            ener = 3;
            energia( 1 );
            energia( 2 );
            energia( 3 );
            vida();
            camara();
            rayo( 460, 118, 0, 0 );
            rayo( 620, 118, 0, 1 );
            rayo( 190, 1223, 0, 0 );
            rayo( 338, 1223, 0, 1 );
            rayo( 530, 1223, 0, 0 );
            rayo( 722, 1223, 0, 1 );
            rayo( 913, 1223, 0, 0 );
            rayo( 1106, 1223, 0, 1 );
            rayo( 1297, 1223, 0, 0 );
            rayo( 1490, 1223, 0, 1 );
            rayo( 1643, 732, 90000, 0 );
            rayo( 1643, 309, 90000, 0 );
            plat( 640, 768, 0 );
            plat( 509, 768, 1 );
            plat( 360, 768, 0 );
            //plat(640,695,1);
            //plat(100,100,1);
            music_play( canc, -1 );
            repeat
                frame;
            until ( finfase == 1 )
            fade_off( 500 );
            paralo( 5000 );
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            scroll_stop( 0 );
            fpg_unload( level );
            fpg_unload( levelm );
            fpg_unload( rayofpg );
            fpg_unload( platfpg );
            music_unload( canc );
            fade_on( 500 );
        end
        case 5:
            level = fpg_load( "./data/level28b.fpg" );
            levelm = fpg_load( "./data/level2.fpg" );
            platfpg = fpg_load( "./data/plat.fpg" );
            misfpg = fpg_load( "./data/misil.fpg" );
            explofpg = fpg_load( "./data/explo.fpg" );
            rayofpg = fpg_load( "./data/rayo.fpg" );
            shotwav = sound_load( "./data/shot.wav" );
            bomw = sound_load( "./data/boom.wav" );
            canc = music_load( "./data/claustrophobia.ogg" );
            scroll_start( 0, levelm, 3, 0, 0, 4 );
            /*scroll_start(1, levelm, 4, 0, 0, 4);
		scroll[1].z=1000;
		scroll[1].follow=0;
		reflejo();*/
            go(); //control();
            chan = map_get_pixel( level, 997, 0, 0 );
            pare = map_get_pixel( level, 997, 1, 0 );
            techo = map_get_pixel( level, 997, 2, 0 );
            pincha = map_get_pixel( level, 997, 3, 0 );
            salida = map_get_pixel( level, 997, 4, 0 );
            //prota=monete(50,230);
            prota = monete( 84, 227 );
            tipocam();
            ener = 3;
            energia( 1 );
            energia( 2 );
            energia( 3 );
            vida();
            camara();
            music_play( canc, -1 );
            plat( 319, 140, 0 );
            plat( 1725, 175, 0 );
            plat( 1810, 135, 1 );
            plat( 1870, 105, 0 );
            torr( 751, 26, 0, 1, abajo );
            rayo( 880, 40, 0, 0 );
            rayo( 1295, 65, 90000, 0 );
            rayo( 1295, 148, 90000, 1 );
            rayo( 2087, 65, 90000, 1 );
            rayo( 2087, 190, 90000, 0 );
            rayo( 2467, 204, 0, 1 );
            rayo( 2551, 204, 0, 0 );
            rayo( 2637, 204, 0, 1 );
            torr( 2326, 214, 2, 1, arriba );
            puerta( 1198, 157 );
            repeat
                frame;
            until ( finfase == 1 )
            fade_off( 500 );
            paralo( 5000 );
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            scroll_stop( 0 );
            fpg_unload( level );
            fpg_unload( levelm );
            fpg_unload( platfpg );
            fpg_unload( rayofpg );
            fpg_unload( misfpg );
            fpg_unload( explofpg );
            sound_unload( shotwav );
            sound_unload( bomw );
            music_unload( canc );
            fade_on( 500 );
        end
        case 6:
            level = fpg_load( "./data/level38b.fpg" );
            levelm = fpg_load( "./data/level3.fpg" );
            //platfpg=fpg_load("./data/plat.fpg");
            misfpg = fpg_load( "./data/misil.fpg" );
            explofpg = fpg_load( "./data/explo.fpg" );
            rayofpg = fpg_load( "./data/rayo2.fpg" );
            shotwav = sound_load( "./data/shot.wav" );
            bomw = sound_load( "./data/boom.wav" );
            canc = music_load( "./data/claustrophobia.ogg" );
            scroll_start( 0, levelm, 3, 1, 0, 8 );
            /*scroll_start(1, levelm, 4, 0, 0, 4);
		scroll[1].z=1000;
		scroll[1].follow=0;
		reflejo();*/
            go(); //control();
            chan = map_get_pixel( level, 997, 0, 0 );
            pare = map_get_pixel( level, 997, 1, 0 );
            techo = map_get_pixel( level, 997, 2, 0 );
            pincha = map_get_pixel( level, 997, 3, 0 );
            salida = map_get_pixel( level, 997, 4, 0 );
            //prota=monete(50,230);
            prota = monete( 300, 3654 );
            tipocam();
            ener = 3;
            energia( 1 );
            energia( 2 );
            energia( 3 );
            vida();
            camara();
            music_play( canc, -1 );
            subest = 1;
            for ( y = 0; y < 4000; y++ )
                if ( map_get_pixel( level, 1, 0, y ) == techo )
                    if ( subest == 0 )
                        subest = 1;
                    else
                        subest = 0;
                    end
                    rayo( 160, y, 0, subest );
                end
                if ( map_get_pixel( level, 1, 0, y ) == salida )
                    if ( subest == 0 )
                        subest = 1;
                        torr( 285, y, 1, 5, arriba );
                    else
                        subest = 0;
                        torr( 34, y, 0, 5, arriba );
                    end
                end
            end
            repeat
                frame;
            until ( finfase == 1 )
            fade_off( 500 );
            paralo( 5000 );
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            scroll_stop( 0 );
            fpg_unload( level );
            fpg_unload( levelm );
            fpg_unload( rayofpg );
            fpg_unload( misfpg );
            fpg_unload( explofpg );
            sound_unload( shotwav );
            sound_unload( bomw );
            music_unload( canc );
            fade_on( 500 );
        end
        case 3:
            level = fpg_load( "./data/level48b.fpg" );
            levelm = fpg_load( "./data/level4.fpg" );
            //platfpg=fpg_load("./data/plat.fpg");
            misfpg = fpg_load( "./data/misil.fpg" );
            explofpg = fpg_load( "./data/explo.fpg" );
            rayofpg = fpg_load( "./data/rayo2.fpg" );
            shotwav = sound_load( "./data/shot.wav" );
            bomw = sound_load( "./data/boom.wav" );
            canc = music_load( "./data/jungle-fun.ogg" );
            scroll_start( 0, levelm, 3, 0, 0, 0 );
            scroll.flags2 = B_NOCOLORKEY;
            scroll_start( 1, levelm, 4, 0, 0, 3 );
            scroll[ 1 ].z = 1000;
            scroll[ 1 ].follow = 0;
            reflejo();
            go(); //control();
            chan = map_get_pixel( level, 997, 0, 0 );
            pare = map_get_pixel( level, 997, 1, 0 );
            techo = map_get_pixel( level, 997, 2, 0 );
            pincha = map_get_pixel( level, 997, 3, 0 );
            salida = map_get_pixel( level, 997, 4, 0 );
            //prota=monete(50,230);
            prota = monete( 161, 217 );
            tipocam();
            ener = 3;
            energia( 1 );
            energia( 2 );
            energia( 3 );
            vida();
            camara();
            music_play( canc, -1 );
            for ( y = 0; y < 980; y++ )
                if ( map_get_pixel( level, 1, 0, y ) == salida )
                    if ( subest == 0 )
                        subest = 1;
                    else
                        subest = 0;
                    end
                    rayo3( 1359, y -15, 0, subest );
                    rayo3( 1359, y + 15, 0, subest );
                end
            end
            for ( y = 280; y < 980; y++ )
                if ( map_get_pixel( level, 1, 0, y ) == techo )
                    if ( subest == 0 )
                        subest = 1;
                    else
                        subest = 0;
                    end
                    rayo3( 193, y -15, 0, subest );
                    rayo3( 193, y + 25, 0, subest );
                end
            end
            puerta( 1193, 875 );
            puerta( 1023, 875 );
            puerta( 1106, 875 );
            torr( 1495, 849, 1, 1, abajo );
            /*subest=1;
		for(y=0; y<4850; y++)
			if(map_get_pixel(level, 1, 0, y)==techo)
				if(subest==0) subest=1; else subest=0; end
				rayo(160,y,0,subest);
			end

			if(map_get_pixel(level, 1, 0, y)==salida)
				if(subest==0)
				subest=1; torr(285,y,1,5);
				else
				subest=0; torr(34,y,0,5);
				end
			end
		end*/
            repeat
                frame;
            until ( finfase == 1 )
            fade_off( 500 );
            paralo( 5000 );
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            scroll_stop( 0 );
            scroll_stop( 1 );
            clear_screen();
            fpg_unload( level );
            fpg_unload( levelm );
            fpg_unload( rayofpg );
            fpg_unload( misfpg );
            fpg_unload( explofpg );
            sound_unload( shotwav );
            sound_unload( bomw );
            music_unload( canc );
            fade_on( 500 );
        end
        case 4:
            modx = 110;
            level = fpg_load( "./data/level58b.fpg" );
            levelm = fpg_load( "./data/level5.fpg" );
            platfpg = fpg_load( "./data/plat.fpg" );
            misfpg = fpg_load( "./data/misil.fpg" );
            explofpg = fpg_load( "./data/explo.fpg" );
            //		rayofpg=fpg_load("./data/rayo2.fpg");
            shotwav = sound_load( "./data/shot.wav" );
            bomw = sound_load( "./data/boom.wav" );
            canc = music_load( "./data/claustrophobia.ogg" );
            scroll_start( 0, levelm, 3, 0, 0, 0 );
            scroll.flags2 = B_NOCOLORKEY;
            scroll_start( 1, levelm, 4, 0, 0, 3 );
            scroll[ 1 ].z = 1000;
            scroll[ 1 ].follow = 0;
            reflejo();
            go(); //control();
            chan = map_get_pixel( level, 997, 0, 0 );
            pare = map_get_pixel( level, 997, 1, 0 );
            techo = map_get_pixel( level, 997, 2, 0 );
            pincha = map_get_pixel( level, 997, 3, 0 );
            salida = map_get_pixel( level, 997, 4, 0 );
            prota = monete( 59, 119 );
            //prota=monete(2107,455);
            tipocam();
            ener = 3;
            energia( 1 );
            energia( 2 );
            energia( 3 );
            vida();
            camara();
            music_play( canc, -1 );
            for ( x = 200; x < 2746; x++ )
                if ( map_get_pixel( level, 1, x, 0 ) == salida )
                    if ( subest == 0 )
                        subest = 1;
                        plat( x, 80, 0 ); //plat(x,380,1);
                    else
                        subest = 0;
                        plat( x, 180, 1 ); //plat(x,420,0);
                    end
                end
            end
            torr( 1654, 269, 0, 1, abajo );
            torr( 1275, 269, 0, 1, abajo );
            torr( 1275, 450, 2, 1, arriba );
            torr( 896, 269, 0, 1, abajo );
            torr( 1188, 450, 3, 1, arriba );
            torr( 517, 269, 0, 1, abajo );
            torr( 517, 450, 2, 1, arriba );
            torr( 829, 269, 1, 1, abajo );
            torr( 829, 450, 3, 1, arriba );
            subest = 0;
            repeat
                if ( prota.y > 240 and subest == 0 and conf.autocam == 0 )
                    modx = -110;
                    subest = 1;
                end
                frame;
            until ( finfase == 1 )
            fade_off( 500 );
            paralo( 5000 );
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            scroll_stop( 0 );
            scroll_stop( 1 );
            fpg_unload( level );
            fpg_unload( levelm );
            fpg_unload( platfpg );
            fpg_unload( misfpg );
            fpg_unload( explofpg );
            sound_unload( shotwav );
            sound_unload( bomw );
            music_unload( canc );
            fade_on( 500 );
        end
        case 1:
            level = fpg_load( "./data/level68b.fpg" );
            levelm = fpg_load( "./data/level6.fpg" );
            platfpg = fpg_load( "./data/plat.fpg" );
            canc = music_load( "./data/jungle-fun.ogg" );
            scroll_start( 0, levelm, 3, 0, 0, 0 );
            scroll.flags2 = B_NOCOLORKEY;
            scroll_start( 1, levelm, 4, 0, 0, 3 );
            scroll[ 1 ].z = 1000;
            scroll[ 1 ].follow = 0;
            reflejo();
            go(); //control();
            chan = map_get_pixel( level, 997, 0, 0 );
            pare = map_get_pixel( level, 997, 1, 0 );
            techo = map_get_pixel( level, 997, 2, 0 );
            pincha = map_get_pixel( level, 997, 3, 0 );
            salida = map_get_pixel( level, 997, 4, 0 );
            prota = monete( 59, 119 );
            //prota=monete(2107,455);
            tipocam();
            ener = 3;
            energia( 1 );
            energia( 2 );
            energia( 3 );
            vida();
            camara();
            music_play( canc, -1 );
            for ( x = 390; x < 1550; x++ )
                if ( map_get_pixel( level, 1, x, 0 ) == salida )
                    if ( subest == 0 )
                        subest = 1;
                        plat( x, 194, 0 ); //plat(x,380,1);
                    else
                        subest = 0;
                        plat( x, 194, 1 ); //plat(x,420,0);
                    end
                end
            end
            subest = 0;
            repeat
                frame;
            until ( finfase == 1 )
            fade_off( 500 );
            paralo( 5000 );
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            scroll_stop( 0 );
            scroll_stop( 1 );
            fpg_unload( level );
            fpg_unload( levelm );
            fpg_unload( platfpg );
            music_unload( canc );
            fade_on( 500 );
        end
        case 7:
            level = fpg_load( "./data/level98b.fpg" );
            levelm = fpg_load( "./data/level9.fpg" );
            misfpg = fpg_load( "./data/misil.fpg" );
            explofpg = fpg_load( "./data/explo.fpg" );
            //		rayofpg=fpg_load("./data/rayo2.fpg");
            shotwav = sound_load( "./data/shot.wav" );
            bomw = sound_load( "./data/boom.wav" );
            ris = sound_load( "./data/ris.wav" );
            alar = sound_load( "./data/alar.wav" );
            no = sound_load( "./data/no.wav" );
            canc = music_load( "./data/boss.ogg" );
            scroll_start( 0, levelm, 3, 0, 0, 0 );
            go(); //control();
            chan = map_get_pixel( level, 997, 0, 0 );
            pare = map_get_pixel( level, 997, 1, 0 );
            techo = map_get_pixel( level, 997, 2, 0 );
            pincha = map_get_pixel( level, 997, 3, 0 );
            salida = map_get_pixel( level, 997, 4, 0 );
            prota = monete( 59, 119 );
            //prota=monete(2107,455);
            tipocam();
            chisme();
            ener = 3;
            energia( 1 );
            energia( 2 );
            energia( 3 );
            vida();
            camara2();
            //mody=-5; modx=75;
            //finfase=1;
            repeat
                frame;
            until ( finfase == 1 )
            finfase = 0;
            fade_off( 500 );
            paralo( 5000 );
            put_screen( levelm, 2 );
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            //scroll_stop(0);
            if ( est != 0 and vidas != -1 )
                fade_on( 500 );
                scroll_stop( 0 );
                mouse.graph = 0;
                labof();
                repeat
                    frame;
                until ( !get_id( type labof ))
                control();
                scroll_start( 0, levelm, 4, 0, 0, 0 );
                scroll_start( 1, levelm, 1, 0, 0, 2 );
                scroll[ 1 ].z = 200;
                scroll[ 1 ].flags1 = B_ABLEND;
                if ( os_id == OS_GP2X_WIZ )
                    mouse.graph = 0;
                else
                    mouse.graph = 999;
                end
                prota = monofin();
                if ( ener == 0 )
                    ener = 1;
                end
                for ( z = ener; z > 0; z-- )
                    energia( z );
                end
                vida();
                cfall();
                esc( 100 );
                esc( 10 );
                esc( 400 );
                esc( 150 );
                esc( 200 );
                fade_on( 500 );
                nubes();
                repeat
                    frame;
                until ( finfase == 1 )
            end
            fade_off( 500 );
            paralo( 5000 );
            let_me_alone();
            jkeys_set_default_keys();
            jkeys_controller();
            scroll_stop( 0 );
            scroll_stop( 1 );
            clear_screen();
            fpg_unload( level );
            fpg_unload( levelm );
            fpg_unload( misfpg );
            fpg_unload( explofpg );
            sound_unload( shotwav );
            sound_unload( bomw );
            sound_unload( no );
            sound_unload( ris );
            sound_unload( alar );
            music_unload( canc );
            fade_on( 500 );
        end
    end
    if ( est == 1 )
        faseactual++;
        stageid = stage( faseactual );
    else
        prota = menu();
    end
end


process menu()
    private
        int wa, s, m, ojo, ojo2, mico_id;
        byte pa;
begin
    sound_stop( -1 );
    scroll.x0 = 0;
    scroll.y0 = 0;
    file = fpg_load( "./data/menu.fpg" );
    chan = map_get_pixel( file, 997, 0, 0 );
    pare = map_get_pixel( file, 997, 1, 0 );
    techo = map_get_pixel( file, 997, 2, 0 );
    //for(z=0; z<=10; z++) menmonete(rand(10,310),rand(1,239)); end
    if ( conf.fase[ 0 ]
        == 2 ) menmonete( 160, -50 );
    end
    put_screen( file, 1 );
    pa = 1;
    x = 94;
    y = 138;
    graph = 4;
    //flags=B_NOCOLORKEY;
    m = sound_load( "./data/menu.wav" );
    wa = sound_play( m, -1 );
    set_panning( 0, 255, 255 );
    if ( os_id != OS_GP2X_WIZ )
        mouse.file = file;
        mouse.graph = 5;
        mouse.flags = 0;
        frame( 0 );
//        sombracursor();
    end
    ojo = pupi( 0 );
    ojo2 = pupi( 1 );
    //if(os_id!=OS_GP2X_WIZ)
    bplay();
    bquit();
    if ( os_id != OS_GP2X_WIZ )
        boption();
    end
    repeat
        //if(key(_q)) repeat frame; until(!key(_q)) gover(); end
        x = 94;
        y = 138;
        graph = 4;
        subest++;
        angle = fget_angle( x, y, mouse.x, mouse.y );
        frame;
        if ( subest == 120 )
            subest = 0;
            if ( rand( 0, 1 ) == 0 )
                if ( pa == 1 )
                    put_screen( file, 2 );
                    s = sound_play( saltowav, 0 );
                    set_panning( s, 255, 0 );
                    pa = 0;
                else
                    put_screen( file, 1 );
                    s = sound_play( saltowav1, 0 );
                    set_panning( s, 255, 0 );
                    pa = 1;
                end
            end
        end
        get_real_point( 1, offset ojo.x, offset ojo.y );
        if ( mico_id = get_id( type menmonete ))
            x = 27;
            y = 196;
            graph = 21;
            angle = get_angle( mico_id );
            get_real_point( 1, offset ojo2.x, offset ojo2.y );
        end
    until ( est == 10 )
    /*est=128;

repeat set_wav_volume(wa,est); est--; frame; until(est==0)*/
    fade_off( 500 );
    paralo( 5000 );
    fpg_unload( file );
    sound_unload( m );
    let_me_alone();
    jkeys_set_default_keys();
    jkeys_controller();
    fade_on( 500 );
    stageid = stage( faseactual );
    /*write_int(0,10,10,3, offset fps);
write_int(0,10,40,3, offset realx);
write_int(0,10,80,3, offset realy);

write_int(0,50,40,3, offset scroll.x0);
write_int(0,50,80,3, offset scroll.y0);*/
end
