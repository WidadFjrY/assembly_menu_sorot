.model small
.code
                        org     100h

        tdata:      
                        jmp     proses
        layar           db      4000 dup (?)
        menu            db      9,9,'+============================================+',13,10
                        db      9,9,'|              >> >> Menu << <<              |',13,10
                        db      9,9,'+============================================+',13,10
                        db      9,9,'|                                            |',13,10
                        db      9,9,'|  1. Cetak Karakter                         |',13,10
                        db      9,9,'|  2. Teks Berwarna                          |',13,10
                        db      9,9,'|  3. Bawah ke Atas                          |',13,10
                        db      9,9,'|  4. Lain-lain                              |',13,10
                        db      9,9,'|  5. Keluar                                 |',13,10
                        db      9,9,'|                                            |',13,10
                        db      9,9,'+============================================+',13,10
                        db      9,9,'|  MK          : Pemrograman Assembly        |',13,10
                        db      9,9,'|  Program     : UAS                         |',13,10
                        db      9,9,'|  Author      : Widad Al Fajri              |',13,10
                        db      9,9,'|                Robby Fawazzy               |',13,10
                        db      9,9,'+============================================+$'

        menu2           db      9,9,'+============================================+',13,10
                        db      9,9,'|           >> >> Lain-lain << <<            |',13,10
                        db      9,9,'+============================================+',13,10
                        db      9,9,'|                                            |',13,10
                        db      9,9,'|  1. Input Keyboard                         |',13,10
                        db      9,9,'|  2. Percabangan                            |',13,10
                        db      9,9,'|  3. Kembali                                |',13,10
                        db      9,9,'|                                            |',13,10
                        db      9,9,'+============================================+$'

        cetakHuruf      db      'Universitas Islam Al - Ihya', '$'
        alphabet        db      'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

        posx            db      22
        posy            db      8
        panah_atas      equ     72
        panah_bawah     equ     80
        tenter          equ     0dh
        color_attribute equ     0ah

        T_ASCII         DB      13,10,'Ini adalah tombol ASCII : $'
        T_Extended      DB      13,10,'Ini adalah tombol Extended $'

        pertanyaan      db      'Masukkan nilai Anda : $'
        kal1            db      10,'                           Anda Lulus $'
        kal2            db      10,'                         Anda Tidak Lulus $'
        kal3            db      10,'                        Anda Lulus Cumlaude $'
        kal4            db      'Teknik Informatika  $'
        kal5            db      'Tekan Enter Untuk Kembali ke Menu $'




cls macro
                        mov     ax,0600h
                        xor     cx,cx
                        mov     dx,184fh
                        mov     bh,7
                        int     10h
endm

gotoxy macro x,y
                        mov     ah,02
                        xor     bx,bx
                        mov     dh,y
                        mov     dl,x
                        int     10h
endm

simpanl macro
                        local   ulang
                        mov     ax,0b800h
                        mov     es,ax
                        mov     cx,4000
                        xor     bx,bx

        ulang:        
                        mov     al,es:[bx]
                        mov     layar[bx],al
                        inc     bx
                        loop    ulang
endm

balikl macro
                        local   ulang
                        mov     cx,4000
                        xor     bx,bx

        ulang:       
                        mov     al,layar[bx]
                        mov     es:[bx],al
                        inc     bx
                        loop    ulang
endm

sorot macro x, y, color
                        local   ulang
                        mov     bl, y                   
                        mov     al, 160                 
                        mul     bl                      
                        mov     bx, ax                  
                        mov     al, x                   
                        mov     ah, 2                   
                        mul     ah                      
                        add     bx, ax                  
                        inc     bx                      

                        mov     cx, 20                  

        ulang:
                        mov     byte ptr es:[bx], color 
                        add     bx, 2                   
                        loop    ulang                  
endm

readkey macro
                        mov     ah,00
                        int     16h
endm

menul macro string
                        mov     ah,09
                        lea     dx,string
                        int     21h
endm

delay macro
                        push    cx
                        xor     cx,cx

        loop1:      
                        loop    loop1
                        pop     cx
endm

Geser macro PosY
                        push     ax
                        push     bx
                        push     cx
                        xor      cx,cx
                        mov      al,26
                        sub      al,PosY
                        mov      cl,al

        loop2:       
                        mov      al,byte ptr es:[bx]
                        mov      byte ptr es:[bx-160],al

        hilang:     
                        mov      byte ptr es:[bx],' '
                        delay
                        sub      bx,160
                        loop     loop2
                        pop      cx
                        pop      bx
                        pop      ax
endm

proses:     
        cls
        gotoxy          0, 4
        menul           menu
        simpanl
        ulang:      
                        balikl
                        sorot    posx,posy, 0ah
        masukan:    
                        readkey
                        cmp      ah,panah_bawah
                        je       bawah
                        cmp      ah,panah_atas
                        je       ceky
                        cmp      al,tenter
                        jne      masukan
                        jmp      banding
        ceky:       
                        cmp      posy,8
                        je       maxy
                        dec      posy
                        jmp      ulang
        maxy:       
                        mov      posy,12
                        jmp      ulang
        bawah:      
                        cmp      posy,12
                        je       no1y
                        inc      posy
                        jmp      ulang
        no1y:       
                        mov      posy,8
                        jmp      ulang
        banding:    
                        cmp      posy,8
                        je       cetak
                        cmp      posy,9
                        je       warna
                        cmp      posy,10
                        je       prontok
                        cmp      posy,11
                        je       etc
                        cmp      posy,12
                        je       keluar
        keluar:     
                        jmp      selesai
etc:
        jmp             lainlain
cetak:
        cls
        gotoxy          22, 12
        lea             dx, [cetakhuruf] 
        mov             ah, 09h
        int             21h
        readkey
        jmp             proses
        
warna:
        cls
        gotoxy          22, 12
        mov             ah, 09h             
        mov             bh, 0               
        mov             cx, 26              
        lea             si, alphabet        
        print_loop:
                        mov      al, [si]           
                        inc      si                  
                        mov      bl, color_attribute 
                        int      10h                 
                        loop     print_loop         
                        readkey
                        jmp      proses

prontok :    
        cls
        gotoxy          22, 12

        mov             ah, 09
        lea             dx, kal4
        int             21h

        mov             ax, 0B800h
        mov             es, ax

        mov             bx, 3998
        mov             cx, 25

        ulangY:
                        mov      PosY,12
                        push     cx
                        mov      cx,80

        ulangX:
                        cmp      byte ptr es:[bx],33

                        jb       Tdk
                        Geser    PosY
        Tdk:
                        sub      bx,2
                        loop     ulangX
                        pop      cx
                        loop     ulangY

                        gotoxy  22,12
                        mov     ah,09h
                        lea     dx,kal5
                        int     21h

                        readkey
        jmp             proses
        
lainlain:
        cls
        gotoxy          0,7
        menul           menu2
        simpanl
        jmp             ulang2
        ulang2:      
                        balikl
                        sorot   posx,posy, 0ah
        masukan2:    
                        readkey
                        cmp     ah, panah_bawah
                        je      bawah2
                        cmp     ah, panah_atas
                        je      ceky2
                        cmp     al, tenter
                        jne     masukan2
                        jmp     banding2
        ceky2:       
                        cmp     posy, 11
                        je      maxy2
                        dec     posy
                        jmp     ulang2
        maxy2:       
                        mov     posy, 13
                        jmp     ulang2
        bawah2:      
                        cmp     posy, 13
                        je      no1y2
                        inc     posy
                        jmp     ulang2
        no1y2:       
                        mov     posy, 11
                        jmp     ulang2
        banding2:    
                        cmp     posy, 11 
                        je      key
                        cmp     posy, 12
                        je      percabangan
                        cmp     posy, 13
                        je      keluar2
        keluar2:     
                        jmp     proses
        key:            
                        cls
                        gotoxy  22, 12
inputKeyboard:
        mov             ah, 0
        int             16h
        push            ax

        cmp             al, 00
        je              Extended
        ASCII:
                        lea     dx, T_ASCII
                        mov     ah, 09
                        int     21h

                        pop     ax
                        mov     DL, al
                        mov     ah, 2
                        int     21h

                        cmp     al,'Q'
                        je      selesaip
                        cmp     al,'q'
                        je      selesaip
                        JMP     inputKeyboard       

        Extended :
                        lea      dx, T_Extended
                        mov      ah, 09
                        int      21h
                        JMP      inputKeyboard
        selesaip:
                        jmp      proses 
percabangan:
        cls
        gotoxy          22, 12
        lea             dx, pertanyaan
        mov             ah, 9h
        int             21h

        mov             ah, 0
        int             16h
        push            ax

        pop             ax
        mov             dl, al
        mov             ah, 2
        int             21h

        cmp             al,'5'
        jbe             tlulus

        cmp             al,'8'
        ja              cumalude

        cmp             al,'5'
        ja              lulus

        lulus:
                        lea      dx,kal1
                        mov      ah,9h
                        int      21h
                        readkey
                        jmp      proses

        tlulus:
                        lea      dx,kal2
                        mov      ah,9h
                        int      21h
                        readkey
                        jmp      proses

        cumalude:
                        lea      dx,kal3
                        mov      ah,9h
                        int      21h
                        readkey
                        jmp      proses        
        selesai:    
                        int      20h
end tdata