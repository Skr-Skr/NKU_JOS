
obj/user/pingpong:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 8d 00 00 00       	call   8000be <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;
	//cprintf("the peid = %d\n", sys_getenvid());
	if ((who = fork()) != 0) {
  80003c:	e8 3a 0e 00 00       	call   800e7b <fork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	74 27                	je     80006f <umain+0x3c>
  800048:	89 c3                	mov    %eax,%ebx
		// get the ball rolling
		//cprintf("the father = %d\n", who);
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004a:	e8 23 0b 00 00       	call   800b72 <sys_getenvid>
  80004f:	83 ec 04             	sub    $0x4,%esp
  800052:	53                   	push   %ebx
  800053:	50                   	push   %eax
  800054:	68 20 15 80 00       	push   $0x801520
  800059:	e8 4b 01 00 00       	call   8001a9 <cprintf>
		ipc_send(who, 0, 0, 0);
  80005e:	6a 00                	push   $0x0
  800060:	6a 00                	push   $0x0
  800062:	6a 00                	push   $0x0
  800064:	ff 75 e4             	pushl  -0x1c(%ebp)
  800067:	e8 66 10 00 00       	call   8010d2 <ipc_send>
  80006c:	83 c4 20             	add    $0x20,%esp
		//cprintf("send is successful\n");
	}

	while (1) {
		//cprintf("children = 0\n");
		uint32_t i = ipc_recv(&who, 0, 0);
  80006f:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	6a 00                	push   $0x0
  800077:	6a 00                	push   $0x0
  800079:	56                   	push   %esi
  80007a:	e8 c0 0f 00 00       	call   80103f <ipc_recv>
  80007f:	89 c3                	mov    %eax,%ebx
				//cprintf("i =1");
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  800081:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800084:	e8 e9 0a 00 00       	call   800b72 <sys_getenvid>
  800089:	57                   	push   %edi
  80008a:	53                   	push   %ebx
  80008b:	50                   	push   %eax
  80008c:	68 36 15 80 00       	push   $0x801536
  800091:	e8 13 01 00 00       	call   8001a9 <cprintf>
		if (i == 10)
  800096:	83 c4 20             	add    $0x20,%esp
  800099:	83 fb 0a             	cmp    $0xa,%ebx
  80009c:	74 18                	je     8000b6 <umain+0x83>
			return;
		i++;
  80009e:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000a1:	6a 00                	push   $0x0
  8000a3:	6a 00                	push   $0x0
  8000a5:	53                   	push   %ebx
  8000a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000a9:	e8 24 10 00 00       	call   8010d2 <ipc_send>
		
		if (i == 10)
  8000ae:	83 c4 10             	add    $0x10,%esp
  8000b1:	83 fb 0a             	cmp    $0xa,%ebx
  8000b4:	75 bc                	jne    800072 <umain+0x3f>
			return;
	}

}
  8000b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000b9:	5b                   	pop    %ebx
  8000ba:	5e                   	pop    %esi
  8000bb:	5f                   	pop    %edi
  8000bc:	5d                   	pop    %ebp
  8000bd:	c3                   	ret    

008000be <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000be:	55                   	push   %ebp
  8000bf:	89 e5                	mov    %esp,%ebp
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
  8000c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000c6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	//thisenv = 0;
	envid_t envid = sys_getenvid();
  8000c9:	e8 a4 0a 00 00       	call   800b72 <sys_getenvid>
	thisenv = &envs[ENVX(envid)];
  8000ce:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000d6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000db:	a3 04 20 80 00       	mov    %eax,0x802004
	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e0:	85 db                	test   %ebx,%ebx
  8000e2:	7e 07                	jle    8000eb <libmain+0x2d>
		binaryname = argv[0];
  8000e4:	8b 06                	mov    (%esi),%eax
  8000e6:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  8000eb:	83 ec 08             	sub    $0x8,%esp
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
  8000f0:	e8 3e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f5:	e8 0a 00 00 00       	call   800104 <exit>
}
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800100:	5b                   	pop    %ebx
  800101:	5e                   	pop    %esi
  800102:	5d                   	pop    %ebp
  800103:	c3                   	ret    

00800104 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800104:	55                   	push   %ebp
  800105:	89 e5                	mov    %esp,%ebp
  800107:	83 ec 14             	sub    $0x14,%esp
	sys_env_destroy(0);
  80010a:	6a 00                	push   $0x0
  80010c:	e8 20 0a 00 00       	call   800b31 <sys_env_destroy>
}
  800111:	83 c4 10             	add    $0x10,%esp
  800114:	c9                   	leave  
  800115:	c3                   	ret    

00800116 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	53                   	push   %ebx
  80011a:	83 ec 04             	sub    $0x4,%esp
  80011d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800120:	8b 13                	mov    (%ebx),%edx
  800122:	8d 42 01             	lea    0x1(%edx),%eax
  800125:	89 03                	mov    %eax,(%ebx)
  800127:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80012e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800133:	75 1a                	jne    80014f <putch+0x39>
		sys_cputs(b->buf, b->idx);
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 ff 00 00 00       	push   $0xff
  80013d:	8d 43 08             	lea    0x8(%ebx),%eax
  800140:	50                   	push   %eax
  800141:	e8 ae 09 00 00       	call   800af4 <sys_cputs>
		b->idx = 0;
  800146:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80014c:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80014f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800156:	c9                   	leave  
  800157:	c3                   	ret    

00800158 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800161:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800168:	00 00 00 
	b.cnt = 0;
  80016b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800172:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800175:	ff 75 0c             	pushl  0xc(%ebp)
  800178:	ff 75 08             	pushl  0x8(%ebp)
  80017b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800181:	50                   	push   %eax
  800182:	68 16 01 80 00       	push   $0x800116
  800187:	e8 1a 01 00 00       	call   8002a6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018c:	83 c4 08             	add    $0x8,%esp
  80018f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800195:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019b:	50                   	push   %eax
  80019c:	e8 53 09 00 00       	call   800af4 <sys_cputs>

	return b.cnt;
}
  8001a1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a7:	c9                   	leave  
  8001a8:	c3                   	ret    

008001a9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001af:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b2:	50                   	push   %eax
  8001b3:	ff 75 08             	pushl  0x8(%ebp)
  8001b6:	e8 9d ff ff ff       	call   800158 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001bb:	c9                   	leave  
  8001bc:	c3                   	ret    

008001bd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	57                   	push   %edi
  8001c1:	56                   	push   %esi
  8001c2:	53                   	push   %ebx
  8001c3:	83 ec 1c             	sub    $0x1c,%esp
  8001c6:	89 c7                	mov    %eax,%edi
  8001c8:	89 d6                	mov    %edx,%esi
  8001ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001de:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e1:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001e4:	39 d3                	cmp    %edx,%ebx
  8001e6:	72 05                	jb     8001ed <printnum+0x30>
  8001e8:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001eb:	77 45                	ja     800232 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001ed:	83 ec 0c             	sub    $0xc,%esp
  8001f0:	ff 75 18             	pushl  0x18(%ebp)
  8001f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001f6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001f9:	53                   	push   %ebx
  8001fa:	ff 75 10             	pushl  0x10(%ebp)
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	ff 75 e4             	pushl  -0x1c(%ebp)
  800203:	ff 75 e0             	pushl  -0x20(%ebp)
  800206:	ff 75 dc             	pushl  -0x24(%ebp)
  800209:	ff 75 d8             	pushl  -0x28(%ebp)
  80020c:	e8 7f 10 00 00       	call   801290 <__udivdi3>
  800211:	83 c4 18             	add    $0x18,%esp
  800214:	52                   	push   %edx
  800215:	50                   	push   %eax
  800216:	89 f2                	mov    %esi,%edx
  800218:	89 f8                	mov    %edi,%eax
  80021a:	e8 9e ff ff ff       	call   8001bd <printnum>
  80021f:	83 c4 20             	add    $0x20,%esp
  800222:	eb 18                	jmp    80023c <printnum+0x7f>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	56                   	push   %esi
  800228:	ff 75 18             	pushl  0x18(%ebp)
  80022b:	ff d7                	call   *%edi
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	eb 03                	jmp    800235 <printnum+0x78>
  800232:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800235:	83 eb 01             	sub    $0x1,%ebx
  800238:	85 db                	test   %ebx,%ebx
  80023a:	7f e8                	jg     800224 <printnum+0x67>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	56                   	push   %esi
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	ff 75 e4             	pushl  -0x1c(%ebp)
  800246:	ff 75 e0             	pushl  -0x20(%ebp)
  800249:	ff 75 dc             	pushl  -0x24(%ebp)
  80024c:	ff 75 d8             	pushl  -0x28(%ebp)
  80024f:	e8 6c 11 00 00       	call   8013c0 <__umoddi3>
  800254:	83 c4 14             	add    $0x14,%esp
  800257:	0f be 80 53 15 80 00 	movsbl 0x801553(%eax),%eax
  80025e:	50                   	push   %eax
  80025f:	ff d7                	call   *%edi
}
  800261:	83 c4 10             	add    $0x10,%esp
  800264:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5f                   	pop    %edi
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800272:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800276:	8b 10                	mov    (%eax),%edx
  800278:	3b 50 04             	cmp    0x4(%eax),%edx
  80027b:	73 0a                	jae    800287 <sprintputch+0x1b>
		*b->buf++ = ch;
  80027d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800280:	89 08                	mov    %ecx,(%eax)
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	88 02                	mov    %al,(%edx)
}
  800287:	5d                   	pop    %ebp
  800288:	c3                   	ret    

00800289 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80028f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800292:	50                   	push   %eax
  800293:	ff 75 10             	pushl  0x10(%ebp)
  800296:	ff 75 0c             	pushl  0xc(%ebp)
  800299:	ff 75 08             	pushl  0x8(%ebp)
  80029c:	e8 05 00 00 00       	call   8002a6 <vprintfmt>
	va_end(ap);
}
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	57                   	push   %edi
  8002aa:	56                   	push   %esi
  8002ab:	53                   	push   %ebx
  8002ac:	83 ec 2c             	sub    $0x2c,%esp
  8002af:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b5:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b8:	eb 12                	jmp    8002cc <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002ba:	85 c0                	test   %eax,%eax
  8002bc:	0f 84 42 04 00 00    	je     800704 <vprintfmt+0x45e>
				return;
			putch(ch, putdat);
  8002c2:	83 ec 08             	sub    $0x8,%esp
  8002c5:	53                   	push   %ebx
  8002c6:	50                   	push   %eax
  8002c7:	ff d6                	call   *%esi
  8002c9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8002cc:	83 c7 01             	add    $0x1,%edi
  8002cf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8002d3:	83 f8 25             	cmp    $0x25,%eax
  8002d6:	75 e2                	jne    8002ba <vprintfmt+0x14>
  8002d8:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002dc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002e3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002ea:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f6:	eb 07                	jmp    8002ff <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8002f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi

		// flag to pad on the right
		case '-':
			padc = '-';
  8002fb:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8002ff:	8d 47 01             	lea    0x1(%edi),%eax
  800302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800305:	0f b6 07             	movzbl (%edi),%eax
  800308:	0f b6 d0             	movzbl %al,%edx
  80030b:	83 e8 23             	sub    $0x23,%eax
  80030e:	3c 55                	cmp    $0x55,%al
  800310:	0f 87 d3 03 00 00    	ja     8006e9 <vprintfmt+0x443>
  800316:	0f b6 c0             	movzbl %al,%eax
  800319:	ff 24 85 20 16 80 00 	jmp    *0x801620(,%eax,4)
  800320:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800323:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800327:	eb d6                	jmp    8002ff <vprintfmt+0x59>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80032c:	b8 00 00 00 00       	mov    $0x0,%eax
  800331:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800334:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800337:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  80033b:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80033e:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800341:	83 f9 09             	cmp    $0x9,%ecx
  800344:	77 3f                	ja     800385 <vprintfmt+0xdf>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800346:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800349:	eb e9                	jmp    800334 <vprintfmt+0x8e>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80034b:	8b 45 14             	mov    0x14(%ebp),%eax
  80034e:	8b 00                	mov    (%eax),%eax
  800350:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800353:	8b 45 14             	mov    0x14(%ebp),%eax
  800356:	8d 40 04             	lea    0x4(%eax),%eax
  800359:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80035c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  80035f:	eb 2a                	jmp    80038b <vprintfmt+0xe5>
  800361:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800364:	85 c0                	test   %eax,%eax
  800366:	ba 00 00 00 00       	mov    $0x0,%edx
  80036b:	0f 49 d0             	cmovns %eax,%edx
  80036e:	89 55 e0             	mov    %edx,-0x20(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800374:	eb 89                	jmp    8002ff <vprintfmt+0x59>
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800379:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800380:	e9 7a ff ff ff       	jmp    8002ff <vprintfmt+0x59>
  800385:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800388:	89 45 d0             	mov    %eax,-0x30(%ebp)

		process_precision:
			if (width < 0)
  80038b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038f:	0f 89 6a ff ff ff    	jns    8002ff <vprintfmt+0x59>
				width = precision, precision = -1;
  800395:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800398:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80039b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003a2:	e9 58 ff ff ff       	jmp    8002ff <vprintfmt+0x59>
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003a7:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003ad:	e9 4d ff ff ff       	jmp    8002ff <vprintfmt+0x59>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 78 04             	lea    0x4(%eax),%edi
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	53                   	push   %ebx
  8003bc:	ff 30                	pushl  (%eax)
  8003be:	ff d6                	call   *%esi
			break;
  8003c0:	83 c4 10             	add    $0x10,%esp
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003c3:	89 7d 14             	mov    %edi,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  8003c9:	e9 fe fe ff ff       	jmp    8002cc <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d1:	8d 78 04             	lea    0x4(%eax),%edi
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	99                   	cltd   
  8003d7:	31 d0                	xor    %edx,%eax
  8003d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003db:	83 f8 09             	cmp    $0x9,%eax
  8003de:	7f 0b                	jg     8003eb <vprintfmt+0x145>
  8003e0:	8b 14 85 80 17 80 00 	mov    0x801780(,%eax,4),%edx
  8003e7:	85 d2                	test   %edx,%edx
  8003e9:	75 1b                	jne    800406 <vprintfmt+0x160>
				printfmt(putch, putdat, "error %d", err);
  8003eb:	50                   	push   %eax
  8003ec:	68 6b 15 80 00       	push   $0x80156b
  8003f1:	53                   	push   %ebx
  8003f2:	56                   	push   %esi
  8003f3:	e8 91 fe ff ff       	call   800289 <printfmt>
  8003f8:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003fb:	89 7d 14             	mov    %edi,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  800401:	e9 c6 fe ff ff       	jmp    8002cc <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  800406:	52                   	push   %edx
  800407:	68 74 15 80 00       	push   $0x801574
  80040c:	53                   	push   %ebx
  80040d:	56                   	push   %esi
  80040e:	e8 76 fe ff ff       	call   800289 <printfmt>
  800413:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
			break;

		// error message
		case 'e':
			err = va_arg(ap, int);
  800416:	89 7d 14             	mov    %edi,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800419:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80041c:	e9 ab fe ff ff       	jmp    8002cc <vprintfmt+0x26>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	83 c0 04             	add    $0x4,%eax
  800427:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80042a:	8b 45 14             	mov    0x14(%ebp),%eax
  80042d:	8b 38                	mov    (%eax),%edi
				p = "(null)";
  80042f:	85 ff                	test   %edi,%edi
  800431:	b8 64 15 80 00       	mov    $0x801564,%eax
  800436:	0f 44 f8             	cmove  %eax,%edi
			if (width > 0 && padc != '-')
  800439:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80043d:	0f 8e 94 00 00 00    	jle    8004d7 <vprintfmt+0x231>
  800443:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800447:	0f 84 98 00 00 00    	je     8004e5 <vprintfmt+0x23f>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	ff 75 d0             	pushl  -0x30(%ebp)
  800453:	57                   	push   %edi
  800454:	e8 33 03 00 00       	call   80078c <strnlen>
  800459:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80045c:	29 c1                	sub    %eax,%ecx
  80045e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800461:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800464:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800468:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046b:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80046e:	89 cf                	mov    %ecx,%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800470:	eb 0f                	jmp    800481 <vprintfmt+0x1db>
					putch(padc, putdat);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	53                   	push   %ebx
  800476:	ff 75 e0             	pushl  -0x20(%ebp)
  800479:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80047b:	83 ef 01             	sub    $0x1,%edi
  80047e:	83 c4 10             	add    $0x10,%esp
  800481:	85 ff                	test   %edi,%edi
  800483:	7f ed                	jg     800472 <vprintfmt+0x1cc>
  800485:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800488:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80048b:	85 c9                	test   %ecx,%ecx
  80048d:	b8 00 00 00 00       	mov    $0x0,%eax
  800492:	0f 49 c1             	cmovns %ecx,%eax
  800495:	29 c1                	sub    %eax,%ecx
  800497:	89 75 08             	mov    %esi,0x8(%ebp)
  80049a:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80049d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004a0:	89 cb                	mov    %ecx,%ebx
  8004a2:	eb 4d                	jmp    8004f1 <vprintfmt+0x24b>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004a4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a8:	74 1b                	je     8004c5 <vprintfmt+0x21f>
  8004aa:	0f be c0             	movsbl %al,%eax
  8004ad:	83 e8 20             	sub    $0x20,%eax
  8004b0:	83 f8 5e             	cmp    $0x5e,%eax
  8004b3:	76 10                	jbe    8004c5 <vprintfmt+0x21f>
					putch('?', putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	ff 75 0c             	pushl  0xc(%ebp)
  8004bb:	6a 3f                	push   $0x3f
  8004bd:	ff 55 08             	call   *0x8(%ebp)
  8004c0:	83 c4 10             	add    $0x10,%esp
  8004c3:	eb 0d                	jmp    8004d2 <vprintfmt+0x22c>
				else
					putch(ch, putdat);
  8004c5:	83 ec 08             	sub    $0x8,%esp
  8004c8:	ff 75 0c             	pushl  0xc(%ebp)
  8004cb:	52                   	push   %edx
  8004cc:	ff 55 08             	call   *0x8(%ebp)
  8004cf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004d2:	83 eb 01             	sub    $0x1,%ebx
  8004d5:	eb 1a                	jmp    8004f1 <vprintfmt+0x24b>
  8004d7:	89 75 08             	mov    %esi,0x8(%ebp)
  8004da:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004dd:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004e0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e3:	eb 0c                	jmp    8004f1 <vprintfmt+0x24b>
  8004e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8004e8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004eb:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8004ee:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004f1:	83 c7 01             	add    $0x1,%edi
  8004f4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004f8:	0f be d0             	movsbl %al,%edx
  8004fb:	85 d2                	test   %edx,%edx
  8004fd:	74 23                	je     800522 <vprintfmt+0x27c>
  8004ff:	85 f6                	test   %esi,%esi
  800501:	78 a1                	js     8004a4 <vprintfmt+0x1fe>
  800503:	83 ee 01             	sub    $0x1,%esi
  800506:	79 9c                	jns    8004a4 <vprintfmt+0x1fe>
  800508:	89 df                	mov    %ebx,%edi
  80050a:	8b 75 08             	mov    0x8(%ebp),%esi
  80050d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800510:	eb 18                	jmp    80052a <vprintfmt+0x284>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	53                   	push   %ebx
  800516:	6a 20                	push   $0x20
  800518:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80051a:	83 ef 01             	sub    $0x1,%edi
  80051d:	83 c4 10             	add    $0x10,%esp
  800520:	eb 08                	jmp    80052a <vprintfmt+0x284>
  800522:	89 df                	mov    %ebx,%edi
  800524:	8b 75 08             	mov    0x8(%ebp),%esi
  800527:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80052a:	85 ff                	test   %edi,%edi
  80052c:	7f e4                	jg     800512 <vprintfmt+0x26c>
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80052e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800531:	89 45 14             	mov    %eax,0x14(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800534:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800537:	e9 90 fd ff ff       	jmp    8002cc <vprintfmt+0x26>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80053c:	83 f9 01             	cmp    $0x1,%ecx
  80053f:	7e 19                	jle    80055a <vprintfmt+0x2b4>
		return va_arg(*ap, long long);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8b 50 04             	mov    0x4(%eax),%edx
  800547:	8b 00                	mov    (%eax),%eax
  800549:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80054c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8d 40 08             	lea    0x8(%eax),%eax
  800555:	89 45 14             	mov    %eax,0x14(%ebp)
  800558:	eb 38                	jmp    800592 <vprintfmt+0x2ec>
	else if (lflag)
  80055a:	85 c9                	test   %ecx,%ecx
  80055c:	74 1b                	je     800579 <vprintfmt+0x2d3>
		return va_arg(*ap, long);
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800566:	89 c1                	mov    %eax,%ecx
  800568:	c1 f9 1f             	sar    $0x1f,%ecx
  80056b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 40 04             	lea    0x4(%eax),%eax
  800574:	89 45 14             	mov    %eax,0x14(%ebp)
  800577:	eb 19                	jmp    800592 <vprintfmt+0x2ec>
	else
		return va_arg(*ap, int);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8b 00                	mov    (%eax),%eax
  80057e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800581:	89 c1                	mov    %eax,%ecx
  800583:	c1 f9 1f             	sar    $0x1f,%ecx
  800586:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8d 40 04             	lea    0x4(%eax),%eax
  80058f:	89 45 14             	mov    %eax,0x14(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800592:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800595:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800598:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  80059d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005a1:	0f 89 0e 01 00 00    	jns    8006b5 <vprintfmt+0x40f>
				putch('-', putdat);
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	53                   	push   %ebx
  8005ab:	6a 2d                	push   $0x2d
  8005ad:	ff d6                	call   *%esi
				num = -(long long) num;
  8005af:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005b5:	f7 da                	neg    %edx
  8005b7:	83 d1 00             	adc    $0x0,%ecx
  8005ba:	f7 d9                	neg    %ecx
  8005bc:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005bf:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c4:	e9 ec 00 00 00       	jmp    8006b5 <vprintfmt+0x40f>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005c9:	83 f9 01             	cmp    $0x1,%ecx
  8005cc:	7e 18                	jle    8005e6 <vprintfmt+0x340>
		return va_arg(*ap, unsigned long long);
  8005ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d1:	8b 10                	mov    (%eax),%edx
  8005d3:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d6:	8d 40 08             	lea    0x8(%eax),%eax
  8005d9:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8005dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e1:	e9 cf 00 00 00       	jmp    8006b5 <vprintfmt+0x40f>
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  8005e6:	85 c9                	test   %ecx,%ecx
  8005e8:	74 1a                	je     800604 <vprintfmt+0x35e>
		return va_arg(*ap, unsigned long);
  8005ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ed:	8b 10                	mov    (%eax),%edx
  8005ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f4:	8d 40 04             	lea    0x4(%eax),%eax
  8005f7:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  8005fa:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ff:	e9 b1 00 00 00       	jmp    8006b5 <vprintfmt+0x40f>
	if (lflag >= 2)
		return va_arg(*ap, unsigned long long);
	else if (lflag)
		return va_arg(*ap, unsigned long);
	else
		return va_arg(*ap, unsigned int);
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	b9 00 00 00 00       	mov    $0x0,%ecx
  80060e:	8d 40 04             	lea    0x4(%eax),%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
			base = 10;
  800614:	b8 0a 00 00 00       	mov    $0xa,%eax
  800619:	e9 97 00 00 00       	jmp    8006b5 <vprintfmt+0x40f>
			goto number;

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	53                   	push   %ebx
  800622:	6a 58                	push   $0x58
  800624:	ff d6                	call   *%esi
			putch('X', putdat);
  800626:	83 c4 08             	add    $0x8,%esp
  800629:	53                   	push   %ebx
  80062a:	6a 58                	push   $0x58
  80062c:	ff d6                	call   *%esi
			putch('X', putdat);
  80062e:	83 c4 08             	add    $0x8,%esp
  800631:	53                   	push   %ebx
  800632:	6a 58                	push   $0x58
  800634:	ff d6                	call   *%esi
			break;
  800636:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800639:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
			putch('X', putdat);
			putch('X', putdat);
			break;
  80063c:	e9 8b fc ff ff       	jmp    8002cc <vprintfmt+0x26>

		// pointer
		case 'p':
			putch('0', putdat);
  800641:	83 ec 08             	sub    $0x8,%esp
  800644:	53                   	push   %ebx
  800645:	6a 30                	push   $0x30
  800647:	ff d6                	call   *%esi
			putch('x', putdat);
  800649:	83 c4 08             	add    $0x8,%esp
  80064c:	53                   	push   %ebx
  80064d:	6a 78                	push   $0x78
  80064f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800651:	8b 45 14             	mov    0x14(%ebp),%eax
  800654:	8b 10                	mov    (%eax),%edx
  800656:	b9 00 00 00 00       	mov    $0x0,%ecx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  80065b:	83 c4 10             	add    $0x10,%esp
		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80065e:	8d 40 04             	lea    0x4(%eax),%eax
  800661:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800664:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  800669:	eb 4a                	jmp    8006b5 <vprintfmt+0x40f>
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80066b:	83 f9 01             	cmp    $0x1,%ecx
  80066e:	7e 15                	jle    800685 <vprintfmt+0x3df>
		return va_arg(*ap, unsigned long long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 10                	mov    (%eax),%edx
  800675:	8b 48 04             	mov    0x4(%eax),%ecx
  800678:	8d 40 08             	lea    0x8(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  80067e:	b8 10 00 00 00       	mov    $0x10,%eax
  800683:	eb 30                	jmp    8006b5 <vprintfmt+0x40f>
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
		return va_arg(*ap, unsigned long long);
	else if (lflag)
  800685:	85 c9                	test   %ecx,%ecx
  800687:	74 17                	je     8006a0 <vprintfmt+0x3fa>
		return va_arg(*ap, unsigned long);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	8b 10                	mov    (%eax),%edx
  80068e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800693:	8d 40 04             	lea    0x4(%eax),%eax
  800696:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  800699:	b8 10 00 00 00       	mov    $0x10,%eax
  80069e:	eb 15                	jmp    8006b5 <vprintfmt+0x40f>
	if (lflag >= 2)
		return va_arg(*ap, unsigned long long);
	else if (lflag)
		return va_arg(*ap, unsigned long);
	else
		return va_arg(*ap, unsigned int);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 10                	mov    (%eax),%edx
  8006a5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
			goto number;

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
			base = 16;
  8006b0:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006b5:	83 ec 0c             	sub    $0xc,%esp
  8006b8:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006bc:	57                   	push   %edi
  8006bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8006c0:	50                   	push   %eax
  8006c1:	51                   	push   %ecx
  8006c2:	52                   	push   %edx
  8006c3:	89 da                	mov    %ebx,%edx
  8006c5:	89 f0                	mov    %esi,%eax
  8006c7:	e8 f1 fa ff ff       	call   8001bd <printnum>
			break;
  8006cc:	83 c4 20             	add    $0x20,%esp
  8006cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006d2:	e9 f5 fb ff ff       	jmp    8002cc <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006d7:	83 ec 08             	sub    $0x8,%esp
  8006da:	53                   	push   %ebx
  8006db:	52                   	push   %edx
  8006dc:	ff d6                	call   *%esi
			break;
  8006de:	83 c4 10             	add    $0x10,%esp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  8006e4:	e9 e3 fb ff ff       	jmp    8002cc <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	53                   	push   %ebx
  8006ed:	6a 25                	push   $0x25
  8006ef:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f1:	83 c4 10             	add    $0x10,%esp
  8006f4:	eb 03                	jmp    8006f9 <vprintfmt+0x453>
  8006f6:	83 ef 01             	sub    $0x1,%edi
  8006f9:	80 7f ff 25          	cmpb   $0x25,-0x1(%edi)
  8006fd:	75 f7                	jne    8006f6 <vprintfmt+0x450>
  8006ff:	e9 c8 fb ff ff       	jmp    8002cc <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  800704:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800707:	5b                   	pop    %ebx
  800708:	5e                   	pop    %esi
  800709:	5f                   	pop    %edi
  80070a:	5d                   	pop    %ebp
  80070b:	c3                   	ret    

0080070c <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	83 ec 18             	sub    $0x18,%esp
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800718:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80071b:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80071f:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800722:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800729:	85 c0                	test   %eax,%eax
  80072b:	74 26                	je     800753 <vsnprintf+0x47>
  80072d:	85 d2                	test   %edx,%edx
  80072f:	7e 22                	jle    800753 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800731:	ff 75 14             	pushl  0x14(%ebp)
  800734:	ff 75 10             	pushl  0x10(%ebp)
  800737:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80073a:	50                   	push   %eax
  80073b:	68 6c 02 80 00       	push   $0x80026c
  800740:	e8 61 fb ff ff       	call   8002a6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800745:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800748:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80074e:	83 c4 10             	add    $0x10,%esp
  800751:	eb 05                	jmp    800758 <vsnprintf+0x4c>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800760:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800763:	50                   	push   %eax
  800764:	ff 75 10             	pushl  0x10(%ebp)
  800767:	ff 75 0c             	pushl  0xc(%ebp)
  80076a:	ff 75 08             	pushl  0x8(%ebp)
  80076d:	e8 9a ff ff ff       	call   80070c <vsnprintf>
	va_end(ap);

	return rc;
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80077a:	b8 00 00 00 00       	mov    $0x0,%eax
  80077f:	eb 03                	jmp    800784 <strlen+0x10>
		n++;
  800781:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800784:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800788:	75 f7                	jne    800781 <strlen+0xd>
		n++;
	return n;
}
  80078a:	5d                   	pop    %ebp
  80078b:	c3                   	ret    

0080078c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80078c:	55                   	push   %ebp
  80078d:	89 e5                	mov    %esp,%ebp
  80078f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800792:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800795:	ba 00 00 00 00       	mov    $0x0,%edx
  80079a:	eb 03                	jmp    80079f <strnlen+0x13>
		n++;
  80079c:	83 c2 01             	add    $0x1,%edx
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80079f:	39 c2                	cmp    %eax,%edx
  8007a1:	74 08                	je     8007ab <strnlen+0x1f>
  8007a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8007a7:	75 f3                	jne    80079c <strnlen+0x10>
  8007a9:	89 d0                	mov    %edx,%eax
		n++;
	return n;
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	53                   	push   %ebx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007b7:	89 c2                	mov    %eax,%edx
  8007b9:	83 c2 01             	add    $0x1,%edx
  8007bc:	83 c1 01             	add    $0x1,%ecx
  8007bf:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007c3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007c6:	84 db                	test   %bl,%bl
  8007c8:	75 ef                	jne    8007b9 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007ca:	5b                   	pop    %ebx
  8007cb:	5d                   	pop    %ebp
  8007cc:	c3                   	ret    

008007cd <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	53                   	push   %ebx
  8007d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007d4:	53                   	push   %ebx
  8007d5:	e8 9a ff ff ff       	call   800774 <strlen>
  8007da:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007dd:	ff 75 0c             	pushl  0xc(%ebp)
  8007e0:	01 d8                	add    %ebx,%eax
  8007e2:	50                   	push   %eax
  8007e3:	e8 c5 ff ff ff       	call   8007ad <strcpy>
	return dst;
}
  8007e8:	89 d8                	mov    %ebx,%eax
  8007ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ed:	c9                   	leave  
  8007ee:	c3                   	ret    

008007ef <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	56                   	push   %esi
  8007f3:	53                   	push   %ebx
  8007f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007fa:	89 f3                	mov    %esi,%ebx
  8007fc:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007ff:	89 f2                	mov    %esi,%edx
  800801:	eb 0f                	jmp    800812 <strncpy+0x23>
		*dst++ = *src;
  800803:	83 c2 01             	add    $0x1,%edx
  800806:	0f b6 01             	movzbl (%ecx),%eax
  800809:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80080c:	80 39 01             	cmpb   $0x1,(%ecx)
  80080f:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800812:	39 da                	cmp    %ebx,%edx
  800814:	75 ed                	jne    800803 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800816:	89 f0                	mov    %esi,%eax
  800818:	5b                   	pop    %ebx
  800819:	5e                   	pop    %esi
  80081a:	5d                   	pop    %ebp
  80081b:	c3                   	ret    

0080081c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	56                   	push   %esi
  800820:	53                   	push   %ebx
  800821:	8b 75 08             	mov    0x8(%ebp),%esi
  800824:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800827:	8b 55 10             	mov    0x10(%ebp),%edx
  80082a:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80082c:	85 d2                	test   %edx,%edx
  80082e:	74 21                	je     800851 <strlcpy+0x35>
  800830:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800834:	89 f2                	mov    %esi,%edx
  800836:	eb 09                	jmp    800841 <strlcpy+0x25>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800838:	83 c2 01             	add    $0x1,%edx
  80083b:	83 c1 01             	add    $0x1,%ecx
  80083e:	88 5a ff             	mov    %bl,-0x1(%edx)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800841:	39 c2                	cmp    %eax,%edx
  800843:	74 09                	je     80084e <strlcpy+0x32>
  800845:	0f b6 19             	movzbl (%ecx),%ebx
  800848:	84 db                	test   %bl,%bl
  80084a:	75 ec                	jne    800838 <strlcpy+0x1c>
  80084c:	89 d0                	mov    %edx,%eax
			*dst++ = *src++;
		*dst = '\0';
  80084e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800851:	29 f0                	sub    %esi,%eax
}
  800853:	5b                   	pop    %ebx
  800854:	5e                   	pop    %esi
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085d:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800860:	eb 06                	jmp    800868 <strcmp+0x11>
		p++, q++;
  800862:	83 c1 01             	add    $0x1,%ecx
  800865:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800868:	0f b6 01             	movzbl (%ecx),%eax
  80086b:	84 c0                	test   %al,%al
  80086d:	74 04                	je     800873 <strcmp+0x1c>
  80086f:	3a 02                	cmp    (%edx),%al
  800871:	74 ef                	je     800862 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800873:	0f b6 c0             	movzbl %al,%eax
  800876:	0f b6 12             	movzbl (%edx),%edx
  800879:	29 d0                	sub    %edx,%eax
}
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	53                   	push   %ebx
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	8b 55 0c             	mov    0xc(%ebp),%edx
  800887:	89 c3                	mov    %eax,%ebx
  800889:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80088c:	eb 06                	jmp    800894 <strncmp+0x17>
		n--, p++, q++;
  80088e:	83 c0 01             	add    $0x1,%eax
  800891:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800894:	39 d8                	cmp    %ebx,%eax
  800896:	74 15                	je     8008ad <strncmp+0x30>
  800898:	0f b6 08             	movzbl (%eax),%ecx
  80089b:	84 c9                	test   %cl,%cl
  80089d:	74 04                	je     8008a3 <strncmp+0x26>
  80089f:	3a 0a                	cmp    (%edx),%cl
  8008a1:	74 eb                	je     80088e <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a3:	0f b6 00             	movzbl (%eax),%eax
  8008a6:	0f b6 12             	movzbl (%edx),%edx
  8008a9:	29 d0                	sub    %edx,%eax
  8008ab:	eb 05                	jmp    8008b2 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008ad:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008b2:	5b                   	pop    %ebx
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008bf:	eb 07                	jmp    8008c8 <strchr+0x13>
		if (*s == c)
  8008c1:	38 ca                	cmp    %cl,%dl
  8008c3:	74 0f                	je     8008d4 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008c5:	83 c0 01             	add    $0x1,%eax
  8008c8:	0f b6 10             	movzbl (%eax),%edx
  8008cb:	84 d2                	test   %dl,%dl
  8008cd:	75 f2                	jne    8008c1 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e0:	eb 03                	jmp    8008e5 <strfind+0xf>
  8008e2:	83 c0 01             	add    $0x1,%eax
  8008e5:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  8008e8:	38 ca                	cmp    %cl,%dl
  8008ea:	74 04                	je     8008f0 <strfind+0x1a>
  8008ec:	84 d2                	test   %dl,%dl
  8008ee:	75 f2                	jne    8008e2 <strfind+0xc>
			break;
	return (char *) s;
}
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	57                   	push   %edi
  8008f6:	56                   	push   %esi
  8008f7:	53                   	push   %ebx
  8008f8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008fe:	85 c9                	test   %ecx,%ecx
  800900:	74 36                	je     800938 <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800902:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800908:	75 28                	jne    800932 <memset+0x40>
  80090a:	f6 c1 03             	test   $0x3,%cl
  80090d:	75 23                	jne    800932 <memset+0x40>
		c &= 0xFF;
  80090f:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800913:	89 d3                	mov    %edx,%ebx
  800915:	c1 e3 08             	shl    $0x8,%ebx
  800918:	89 d6                	mov    %edx,%esi
  80091a:	c1 e6 18             	shl    $0x18,%esi
  80091d:	89 d0                	mov    %edx,%eax
  80091f:	c1 e0 10             	shl    $0x10,%eax
  800922:	09 f0                	or     %esi,%eax
  800924:	09 c2                	or     %eax,%edx
		asm volatile("cld; rep stosl\n"
  800926:	89 d8                	mov    %ebx,%eax
  800928:	09 d0                	or     %edx,%eax
  80092a:	c1 e9 02             	shr    $0x2,%ecx
  80092d:	fc                   	cld    
  80092e:	f3 ab                	rep stos %eax,%es:(%edi)
  800930:	eb 06                	jmp    800938 <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800932:	8b 45 0c             	mov    0xc(%ebp),%eax
  800935:	fc                   	cld    
  800936:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800938:	89 f8                	mov    %edi,%eax
  80093a:	5b                   	pop    %ebx
  80093b:	5e                   	pop    %esi
  80093c:	5f                   	pop    %edi
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	57                   	push   %edi
  800943:	56                   	push   %esi
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8b 75 0c             	mov    0xc(%ebp),%esi
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80094d:	39 c6                	cmp    %eax,%esi
  80094f:	73 35                	jae    800986 <memmove+0x47>
  800951:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800954:	39 d0                	cmp    %edx,%eax
  800956:	73 2e                	jae    800986 <memmove+0x47>
		s += n;
		d += n;
  800958:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095b:	89 d6                	mov    %edx,%esi
  80095d:	09 fe                	or     %edi,%esi
  80095f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800965:	75 13                	jne    80097a <memmove+0x3b>
  800967:	f6 c1 03             	test   $0x3,%cl
  80096a:	75 0e                	jne    80097a <memmove+0x3b>
			asm volatile("std; rep movsl\n"
  80096c:	83 ef 04             	sub    $0x4,%edi
  80096f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800972:	c1 e9 02             	shr    $0x2,%ecx
  800975:	fd                   	std    
  800976:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800978:	eb 09                	jmp    800983 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80097a:	83 ef 01             	sub    $0x1,%edi
  80097d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800980:	fd                   	std    
  800981:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800983:	fc                   	cld    
  800984:	eb 1d                	jmp    8009a3 <memmove+0x64>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800986:	89 f2                	mov    %esi,%edx
  800988:	09 c2                	or     %eax,%edx
  80098a:	f6 c2 03             	test   $0x3,%dl
  80098d:	75 0f                	jne    80099e <memmove+0x5f>
  80098f:	f6 c1 03             	test   $0x3,%cl
  800992:	75 0a                	jne    80099e <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
  800994:	c1 e9 02             	shr    $0x2,%ecx
  800997:	89 c7                	mov    %eax,%edi
  800999:	fc                   	cld    
  80099a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099c:	eb 05                	jmp    8009a3 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80099e:	89 c7                	mov    %eax,%edi
  8009a0:	fc                   	cld    
  8009a1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009a3:	5e                   	pop    %esi
  8009a4:	5f                   	pop    %edi
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009aa:	ff 75 10             	pushl  0x10(%ebp)
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	ff 75 08             	pushl  0x8(%ebp)
  8009b3:	e8 87 ff ff ff       	call   80093f <memmove>
}
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    

008009ba <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	56                   	push   %esi
  8009be:	53                   	push   %ebx
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c5:	89 c6                	mov    %eax,%esi
  8009c7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ca:	eb 1a                	jmp    8009e6 <memcmp+0x2c>
		if (*s1 != *s2)
  8009cc:	0f b6 08             	movzbl (%eax),%ecx
  8009cf:	0f b6 1a             	movzbl (%edx),%ebx
  8009d2:	38 d9                	cmp    %bl,%cl
  8009d4:	74 0a                	je     8009e0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009d6:	0f b6 c1             	movzbl %cl,%eax
  8009d9:	0f b6 db             	movzbl %bl,%ebx
  8009dc:	29 d8                	sub    %ebx,%eax
  8009de:	eb 0f                	jmp    8009ef <memcmp+0x35>
		s1++, s2++;
  8009e0:	83 c0 01             	add    $0x1,%eax
  8009e3:	83 c2 01             	add    $0x1,%edx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e6:	39 f0                	cmp    %esi,%eax
  8009e8:	75 e2                	jne    8009cc <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	53                   	push   %ebx
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8009fa:	89 c1                	mov    %eax,%ecx
  8009fc:	03 4d 10             	add    0x10(%ebp),%ecx
	for (; s < ends; s++)
		if (*(const unsigned char *) s == (unsigned char) c)
  8009ff:	0f b6 5d 0c          	movzbl 0xc(%ebp),%ebx

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a03:	eb 0a                	jmp    800a0f <memfind+0x1c>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a05:	0f b6 10             	movzbl (%eax),%edx
  800a08:	39 da                	cmp    %ebx,%edx
  800a0a:	74 07                	je     800a13 <memfind+0x20>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a0c:	83 c0 01             	add    $0x1,%eax
  800a0f:	39 c8                	cmp    %ecx,%eax
  800a11:	72 f2                	jb     800a05 <memfind+0x12>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a13:	5b                   	pop    %ebx
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	57                   	push   %edi
  800a1a:	56                   	push   %esi
  800a1b:	53                   	push   %ebx
  800a1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a22:	eb 03                	jmp    800a27 <strtol+0x11>
		s++;
  800a24:	83 c1 01             	add    $0x1,%ecx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a27:	0f b6 01             	movzbl (%ecx),%eax
  800a2a:	3c 20                	cmp    $0x20,%al
  800a2c:	74 f6                	je     800a24 <strtol+0xe>
  800a2e:	3c 09                	cmp    $0x9,%al
  800a30:	74 f2                	je     800a24 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a32:	3c 2b                	cmp    $0x2b,%al
  800a34:	75 0a                	jne    800a40 <strtol+0x2a>
		s++;
  800a36:	83 c1 01             	add    $0x1,%ecx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a39:	bf 00 00 00 00       	mov    $0x0,%edi
  800a3e:	eb 11                	jmp    800a51 <strtol+0x3b>
  800a40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a45:	3c 2d                	cmp    $0x2d,%al
  800a47:	75 08                	jne    800a51 <strtol+0x3b>
		s++, neg = 1;
  800a49:	83 c1 01             	add    $0x1,%ecx
  800a4c:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a51:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800a57:	75 15                	jne    800a6e <strtol+0x58>
  800a59:	80 39 30             	cmpb   $0x30,(%ecx)
  800a5c:	75 10                	jne    800a6e <strtol+0x58>
  800a5e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a62:	75 7c                	jne    800ae0 <strtol+0xca>
		s += 2, base = 16;
  800a64:	83 c1 02             	add    $0x2,%ecx
  800a67:	bb 10 00 00 00       	mov    $0x10,%ebx
  800a6c:	eb 16                	jmp    800a84 <strtol+0x6e>
	else if (base == 0 && s[0] == '0')
  800a6e:	85 db                	test   %ebx,%ebx
  800a70:	75 12                	jne    800a84 <strtol+0x6e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a72:	bb 0a 00 00 00       	mov    $0xa,%ebx
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a77:	80 39 30             	cmpb   $0x30,(%ecx)
  800a7a:	75 08                	jne    800a84 <strtol+0x6e>
		s++, base = 8;
  800a7c:	83 c1 01             	add    $0x1,%ecx
  800a7f:	bb 08 00 00 00       	mov    $0x8,%ebx
	else if (base == 0)
		base = 10;
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
  800a89:	89 5d 10             	mov    %ebx,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a8c:	0f b6 11             	movzbl (%ecx),%edx
  800a8f:	8d 72 d0             	lea    -0x30(%edx),%esi
  800a92:	89 f3                	mov    %esi,%ebx
  800a94:	80 fb 09             	cmp    $0x9,%bl
  800a97:	77 08                	ja     800aa1 <strtol+0x8b>
			dig = *s - '0';
  800a99:	0f be d2             	movsbl %dl,%edx
  800a9c:	83 ea 30             	sub    $0x30,%edx
  800a9f:	eb 22                	jmp    800ac3 <strtol+0xad>
		else if (*s >= 'a' && *s <= 'z')
  800aa1:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aa4:	89 f3                	mov    %esi,%ebx
  800aa6:	80 fb 19             	cmp    $0x19,%bl
  800aa9:	77 08                	ja     800ab3 <strtol+0x9d>
			dig = *s - 'a' + 10;
  800aab:	0f be d2             	movsbl %dl,%edx
  800aae:	83 ea 57             	sub    $0x57,%edx
  800ab1:	eb 10                	jmp    800ac3 <strtol+0xad>
		else if (*s >= 'A' && *s <= 'Z')
  800ab3:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ab6:	89 f3                	mov    %esi,%ebx
  800ab8:	80 fb 19             	cmp    $0x19,%bl
  800abb:	77 16                	ja     800ad3 <strtol+0xbd>
			dig = *s - 'A' + 10;
  800abd:	0f be d2             	movsbl %dl,%edx
  800ac0:	83 ea 37             	sub    $0x37,%edx
		else
			break;
		if (dig >= base)
  800ac3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ac6:	7d 0b                	jge    800ad3 <strtol+0xbd>
			break;
		s++, val = (val * base) + dig;
  800ac8:	83 c1 01             	add    $0x1,%ecx
  800acb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800acf:	01 d0                	add    %edx,%eax
		// we don't properly detect overflow!
	}
  800ad1:	eb b9                	jmp    800a8c <strtol+0x76>

	if (endptr)
  800ad3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad7:	74 0d                	je     800ae6 <strtol+0xd0>
		*endptr = (char *) s;
  800ad9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adc:	89 0e                	mov    %ecx,(%esi)
  800ade:	eb 06                	jmp    800ae6 <strtol+0xd0>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ae0:	85 db                	test   %ebx,%ebx
  800ae2:	74 98                	je     800a7c <strtol+0x66>
  800ae4:	eb 9e                	jmp    800a84 <strtol+0x6e>
		// we don't properly detect overflow!
	}

	if (endptr)
		*endptr = (char *) s;
	return (neg ? -val : val);
  800ae6:	89 c2                	mov    %eax,%edx
  800ae8:	f7 da                	neg    %edx
  800aea:	85 ff                	test   %edi,%edi
  800aec:	0f 45 c2             	cmovne %edx,%eax
}
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800afa:	b8 00 00 00 00       	mov    $0x0,%eax
  800aff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b02:	8b 55 08             	mov    0x8(%ebp),%edx
  800b05:	89 c3                	mov    %eax,%ebx
  800b07:	89 c7                	mov    %eax,%edi
  800b09:	89 c6                	mov    %eax,%esi
  800b0b:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b0d:	5b                   	pop    %ebx
  800b0e:	5e                   	pop    %esi
  800b0f:	5f                   	pop    %edi
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	57                   	push   %edi
  800b16:	56                   	push   %esi
  800b17:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b18:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1d:	b8 01 00 00 00       	mov    $0x1,%eax
  800b22:	89 d1                	mov    %edx,%ecx
  800b24:	89 d3                	mov    %edx,%ebx
  800b26:	89 d7                	mov    %edx,%edi
  800b28:	89 d6                	mov    %edx,%esi
  800b2a:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b2c:	5b                   	pop    %ebx
  800b2d:	5e                   	pop    %esi
  800b2e:	5f                   	pop    %edi
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    

00800b31 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	57                   	push   %edi
  800b35:	56                   	push   %esi
  800b36:	53                   	push   %ebx
  800b37:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b3f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b44:	8b 55 08             	mov    0x8(%ebp),%edx
  800b47:	89 cb                	mov    %ecx,%ebx
  800b49:	89 cf                	mov    %ecx,%edi
  800b4b:	89 ce                	mov    %ecx,%esi
  800b4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800b4f:	85 c0                	test   %eax,%eax
  800b51:	7e 17                	jle    800b6a <sys_env_destroy+0x39>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b53:	83 ec 0c             	sub    $0xc,%esp
  800b56:	50                   	push   %eax
  800b57:	6a 03                	push   $0x3
  800b59:	68 a8 17 80 00       	push   $0x8017a8
  800b5e:	6a 23                	push   $0x23
  800b60:	68 c5 17 80 00       	push   $0x8017c5
  800b65:	e8 25 06 00 00       	call   80118f <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6d:	5b                   	pop    %ebx
  800b6e:	5e                   	pop    %esi
  800b6f:	5f                   	pop    %edi
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	57                   	push   %edi
  800b76:	56                   	push   %esi
  800b77:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b78:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7d:	b8 02 00 00 00       	mov    $0x2,%eax
  800b82:	89 d1                	mov    %edx,%ecx
  800b84:	89 d3                	mov    %edx,%ebx
  800b86:	89 d7                	mov    %edx,%edi
  800b88:	89 d6                	mov    %edx,%esi
  800b8a:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b8c:	5b                   	pop    %ebx
  800b8d:	5e                   	pop    %esi
  800b8e:	5f                   	pop    %edi
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <sys_yield>:

void
sys_yield(void)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	57                   	push   %edi
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b97:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ba1:	89 d1                	mov    %edx,%ecx
  800ba3:	89 d3                	mov    %edx,%ebx
  800ba5:	89 d7                	mov    %edx,%edi
  800ba7:	89 d6                	mov    %edx,%esi
  800ba9:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bab:	5b                   	pop    %ebx
  800bac:	5e                   	pop    %esi
  800bad:	5f                   	pop    %edi
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	57                   	push   %edi
  800bb4:	56                   	push   %esi
  800bb5:	53                   	push   %ebx
  800bb6:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bb9:	be 00 00 00 00       	mov    $0x0,%esi
  800bbe:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bcc:	89 f7                	mov    %esi,%edi
  800bce:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bd0:	85 c0                	test   %eax,%eax
  800bd2:	7e 17                	jle    800beb <sys_page_alloc+0x3b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd4:	83 ec 0c             	sub    $0xc,%esp
  800bd7:	50                   	push   %eax
  800bd8:	6a 04                	push   $0x4
  800bda:	68 a8 17 80 00       	push   $0x8017a8
  800bdf:	6a 23                	push   $0x23
  800be1:	68 c5 17 80 00       	push   $0x8017c5
  800be6:	e8 a4 05 00 00       	call   80118f <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfc:	b8 05 00 00 00       	mov    $0x5,%eax
  800c01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c04:	8b 55 08             	mov    0x8(%ebp),%edx
  800c07:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c0d:	8b 75 18             	mov    0x18(%ebp),%esi
  800c10:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c12:	85 c0                	test   %eax,%eax
  800c14:	7e 17                	jle    800c2d <sys_page_map+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	6a 05                	push   $0x5
  800c1c:	68 a8 17 80 00       	push   $0x8017a8
  800c21:	6a 23                	push   $0x23
  800c23:	68 c5 17 80 00       	push   $0x8017c5
  800c28:	e8 62 05 00 00       	call   80118f <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
  800c3b:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c43:	b8 06 00 00 00       	mov    $0x6,%eax
  800c48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4e:	89 df                	mov    %ebx,%edi
  800c50:	89 de                	mov    %ebx,%esi
  800c52:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c54:	85 c0                	test   %eax,%eax
  800c56:	7e 17                	jle    800c6f <sys_page_unmap+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c58:	83 ec 0c             	sub    $0xc,%esp
  800c5b:	50                   	push   %eax
  800c5c:	6a 06                	push   $0x6
  800c5e:	68 a8 17 80 00       	push   $0x8017a8
  800c63:	6a 23                	push   $0x23
  800c65:	68 c5 17 80 00       	push   $0x8017c5
  800c6a:	e8 20 05 00 00       	call   80118f <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	5d                   	pop    %ebp
  800c76:	c3                   	ret    

00800c77 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c85:	b8 08 00 00 00       	mov    $0x8,%eax
  800c8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c90:	89 df                	mov    %ebx,%edi
  800c92:	89 de                	mov    %ebx,%esi
  800c94:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c96:	85 c0                	test   %eax,%eax
  800c98:	7e 17                	jle    800cb1 <sys_env_set_status+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9a:	83 ec 0c             	sub    $0xc,%esp
  800c9d:	50                   	push   %eax
  800c9e:	6a 08                	push   $0x8
  800ca0:	68 a8 17 80 00       	push   $0x8017a8
  800ca5:	6a 23                	push   $0x23
  800ca7:	68 c5 17 80 00       	push   $0x8017c5
  800cac:	e8 de 04 00 00       	call   80118f <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	57                   	push   %edi
  800cbd:	56                   	push   %esi
  800cbe:	53                   	push   %ebx
  800cbf:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc7:	b8 09 00 00 00       	mov    $0x9,%eax
  800ccc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd2:	89 df                	mov    %ebx,%edi
  800cd4:	89 de                	mov    %ebx,%esi
  800cd6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd8:	85 c0                	test   %eax,%eax
  800cda:	7e 17                	jle    800cf3 <sys_env_set_pgfault_upcall+0x3a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdc:	83 ec 0c             	sub    $0xc,%esp
  800cdf:	50                   	push   %eax
  800ce0:	6a 09                	push   $0x9
  800ce2:	68 a8 17 80 00       	push   $0x8017a8
  800ce7:	6a 23                	push   $0x23
  800ce9:	68 c5 17 80 00       	push   $0x8017c5
  800cee:	e8 9c 04 00 00       	call   80118f <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf6:	5b                   	pop    %ebx
  800cf7:	5e                   	pop    %esi
  800cf8:	5f                   	pop    %edi
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d01:	be 00 00 00 00       	mov    $0x0,%esi
  800d06:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d11:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d14:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d17:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
  800d24:	83 ec 0c             	sub    $0xc,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d27:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d2c:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d31:	8b 55 08             	mov    0x8(%ebp),%edx
  800d34:	89 cb                	mov    %ecx,%ebx
  800d36:	89 cf                	mov    %ecx,%edi
  800d38:	89 ce                	mov    %ecx,%esi
  800d3a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d3c:	85 c0                	test   %eax,%eax
  800d3e:	7e 17                	jle    800d57 <sys_ipc_recv+0x39>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d40:	83 ec 0c             	sub    $0xc,%esp
  800d43:	50                   	push   %eax
  800d44:	6a 0c                	push   $0xc
  800d46:	68 a8 17 80 00       	push   $0x8017a8
  800d4b:	6a 23                	push   $0x23
  800d4d:	68 c5 17 80 00       	push   $0x8017c5
  800d52:	e8 38 04 00 00       	call   80118f <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5a:	5b                   	pop    %ebx
  800d5b:	5e                   	pop    %esi
  800d5c:	5f                   	pop    %edi
  800d5d:	5d                   	pop    %ebp
  800d5e:	c3                   	ret    

00800d5f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800d5f:	55                   	push   %ebp
  800d60:	89 e5                	mov    %esp,%ebp
  800d62:	56                   	push   %esi
  800d63:	53                   	push   %ebx
  800d64:	8b 75 08             	mov    0x8(%ebp),%esi


	void *addr = (void *) utf->utf_fault_va;
  800d67:	8b 1e                	mov    (%esi),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if( (err & FEC_WR) == 0){
  800d69:	f6 46 04 02          	testb  $0x2,0x4(%esi)
  800d6d:	75 32                	jne    800da1 <pgfault+0x42>
		//cprintf(	" The eid = %x\n", sys_getenvid());
		//cprintf("The err is %d\n", err);
		cprintf("The va is 0x%x\n", (int)addr );
  800d6f:	83 ec 08             	sub    $0x8,%esp
  800d72:	53                   	push   %ebx
  800d73:	68 d3 17 80 00       	push   $0x8017d3
  800d78:	e8 2c f4 ff ff       	call   8001a9 <cprintf>
		cprintf("The Eip is 0x%x\n", utf->utf_eip);
  800d7d:	83 c4 08             	add    $0x8,%esp
  800d80:	ff 76 28             	pushl  0x28(%esi)
  800d83:	68 e3 17 80 00       	push   $0x8017e3
  800d88:	e8 1c f4 ff ff       	call   8001a9 <cprintf>

		 panic("The err is not right of the pgfault\n ");
  800d8d:	83 c4 0c             	add    $0xc,%esp
  800d90:	68 28 18 80 00       	push   $0x801828
  800d95:	6a 24                	push   $0x24
  800d97:	68 f4 17 80 00       	push   $0x8017f4
  800d9c:	e8 ee 03 00 00       	call   80118f <_panic>
	}

	pte_t PTE =uvpt[PGNUM(addr)];
  800da1:	89 d8                	mov    %ebx,%eax
  800da3:	c1 e8 0c             	shr    $0xc,%eax
  800da6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax

	if( (PTE & PTE_COW) == 0)
  800dad:	f6 c4 08             	test   $0x8,%ah
  800db0:	75 14                	jne    800dc6 <pgfault+0x67>
		panic("The pgfault perm is not right\n");
  800db2:	83 ec 04             	sub    $0x4,%esp
  800db5:	68 50 18 80 00       	push   $0x801850
  800dba:	6a 2a                	push   $0x2a
  800dbc:	68 f4 17 80 00       	push   $0x8017f4
  800dc1:	e8 c9 03 00 00       	call   80118f <_panic>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	if(sys_page_alloc(sys_getenvid(), (void*)PFTEMP, PTE_U|PTE_W|PTE_P) <0 )
  800dc6:	e8 a7 fd ff ff       	call   800b72 <sys_getenvid>
  800dcb:	83 ec 04             	sub    $0x4,%esp
  800dce:	6a 07                	push   $0x7
  800dd0:	68 00 f0 7f 00       	push   $0x7ff000
  800dd5:	50                   	push   %eax
  800dd6:	e8 d5 fd ff ff       	call   800bb0 <sys_page_alloc>
  800ddb:	83 c4 10             	add    $0x10,%esp
  800dde:	85 c0                	test   %eax,%eax
  800de0:	79 14                	jns    800df6 <pgfault+0x97>
		panic("pgfault sys_page_alloc is not right\n");
  800de2:	83 ec 04             	sub    $0x4,%esp
  800de5:	68 70 18 80 00       	push   $0x801870
  800dea:	6a 34                	push   $0x34
  800dec:	68 f4 17 80 00       	push   $0x8017f4
  800df1:	e8 99 03 00 00       	call   80118f <_panic>
	addr = ROUNDDOWN(addr, PGSIZE);
  800df6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy((void*)PFTEMP, addr, PGSIZE);
  800dfc:	83 ec 04             	sub    $0x4,%esp
  800dff:	68 00 10 00 00       	push   $0x1000
  800e04:	53                   	push   %ebx
  800e05:	68 00 f0 7f 00       	push   $0x7ff000
  800e0a:	e8 98 fb ff ff       	call   8009a7 <memcpy>

	if((r = sys_page_map(sys_getenvid(), (void*)PFTEMP, sys_getenvid(), addr, PTE_U|PTE_W|PTE_P)) < 0)
  800e0f:	e8 5e fd ff ff       	call   800b72 <sys_getenvid>
  800e14:	89 c6                	mov    %eax,%esi
  800e16:	e8 57 fd ff ff       	call   800b72 <sys_getenvid>
  800e1b:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e22:	53                   	push   %ebx
  800e23:	56                   	push   %esi
  800e24:	68 00 f0 7f 00       	push   $0x7ff000
  800e29:	50                   	push   %eax
  800e2a:	e8 c4 fd ff ff       	call   800bf3 <sys_page_map>
  800e2f:	83 c4 20             	add    $0x20,%esp
  800e32:	85 c0                	test   %eax,%eax
  800e34:	79 12                	jns    800e48 <pgfault+0xe9>
		panic("The sys_page_map is not right, the errno is %d\n", r);
  800e36:	50                   	push   %eax
  800e37:	68 98 18 80 00       	push   $0x801898
  800e3c:	6a 39                	push   $0x39
  800e3e:	68 f4 17 80 00       	push   $0x8017f4
  800e43:	e8 47 03 00 00       	call   80118f <_panic>
	if( (r = sys_page_unmap(sys_getenvid(), (void*)PFTEMP)) <0 )
  800e48:	e8 25 fd ff ff       	call   800b72 <sys_getenvid>
  800e4d:	83 ec 08             	sub    $0x8,%esp
  800e50:	68 00 f0 7f 00       	push   $0x7ff000
  800e55:	50                   	push   %eax
  800e56:	e8 da fd ff ff       	call   800c35 <sys_page_unmap>
  800e5b:	83 c4 10             	add    $0x10,%esp
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	79 12                	jns    800e74 <pgfault+0x115>
		panic("The sys_page_unmap is not right, the errno is %d\n",r);
  800e62:	50                   	push   %eax
  800e63:	68 c8 18 80 00       	push   $0x8018c8
  800e68:	6a 3b                	push   $0x3b
  800e6a:	68 f4 17 80 00       	push   $0x8017f4
  800e6f:	e8 1b 03 00 00       	call   80118f <_panic>
	return;

	

	//panic("pgfault not implemented");
}
  800e74:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
  800e81:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	
	extern void*  _pgfault_upcall();
	//build the experition stack for the parent env
	set_pgfault_handler(pgfault);
  800e84:	68 5f 0d 80 00       	push   $0x800d5f
  800e89:	e8 47 03 00 00       	call   8011d5 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  800e8e:	b8 07 00 00 00       	mov    $0x7,%eax
  800e93:	cd 30                	int    $0x30
  800e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e98:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int childEid = sys_exofork();
	if(childEid < 0)
  800e9b:	83 c4 10             	add    $0x10,%esp
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	79 15                	jns    800eb7 <fork+0x3c>
		panic("sys_exofork() is not right, and the errno is  %d\n",childEid);
  800ea2:	50                   	push   %eax
  800ea3:	68 fc 18 80 00       	push   $0x8018fc
  800ea8:	68 82 00 00 00       	push   $0x82
  800ead:	68 f4 17 80 00       	push   $0x8017f4
  800eb2:	e8 d8 02 00 00       	call   80118f <_panic>
	if(childEid == 0){
  800eb7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ebb:	75 1c                	jne    800ed9 <fork+0x5e>
		thisenv = &envs[ENVX(sys_getenvid())];
  800ebd:	e8 b0 fc ff ff       	call   800b72 <sys_getenvid>
  800ec2:	25 ff 03 00 00       	and    $0x3ff,%eax
  800ec7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800eca:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ecf:	a3 04 20 80 00       	mov    %eax,0x802004
		return childEid;
  800ed4:	e9 41 01 00 00       	jmp    80101a <fork+0x19f>
	}

	int r = sys_env_set_pgfault_upcall(childEid,  _pgfault_upcall);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	68 4b 12 80 00       	push   $0x80124b
  800ee1:	ff 75 e0             	pushl  -0x20(%ebp)
  800ee4:	e8 d0 fd ff ff       	call   800cb9 <sys_env_set_pgfault_upcall>
  800ee9:	89 c7                	mov    %eax,%edi
	if(r < 0)
  800eeb:	83 c4 10             	add    $0x10,%esp
  800eee:	85 c0                	test   %eax,%eax
  800ef0:	79 15                	jns    800f07 <fork+0x8c>
		panic("sys_env_set_pgfault_upcall is not right ,and the errno is %d\n", r);
  800ef2:	50                   	push   %eax
  800ef3:	68 30 19 80 00       	push   $0x801930
  800ef8:	68 8a 00 00 00       	push   $0x8a
  800efd:	68 f4 17 80 00       	push   $0x8017f4
  800f02:	e8 88 02 00 00       	call   80118f <_panic>
  800f07:	bb 00 00 00 00       	mov    $0x0,%ebx
	

	int pn =0;
	for(pn=0; pn*PGSIZE < UTOP ; pn++){
		if ( ( 	(uvpd[PDX(pn*PGSIZE)] & PTE_P) != 0) &&
  800f0c:	89 d8                	mov    %ebx,%eax
  800f0e:	c1 e8 16             	shr    $0x16,%eax
  800f11:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f18:	a8 01                	test   $0x1,%al
  800f1a:	0f 84 bd 00 00 00    	je     800fdd <fork+0x162>
				( (uvpt[PGNUM(pn*PGSIZE)] & PTE_U) != 0) &&
  800f20:	89 d8                	mov    %ebx,%eax
  800f22:	c1 e8 0c             	shr    $0xc,%eax
  800f25:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
		panic("sys_env_set_pgfault_upcall is not right ,and the errno is %d\n", r);
	

	int pn =0;
	for(pn=0; pn*PGSIZE < UTOP ; pn++){
		if ( ( 	(uvpd[PDX(pn*PGSIZE)] & PTE_P) != 0) &&
  800f2c:	f6 c2 04             	test   $0x4,%dl
  800f2f:	0f 84 a8 00 00 00    	je     800fdd <fork+0x162>
				( (uvpt[PGNUM(pn*PGSIZE)] & PTE_U) != 0) &&
				( (uvpt[PGNUM(pn*PGSIZE)] & PTE_P) != 0))
  800f35:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
	

	int pn =0;
	for(pn=0; pn*PGSIZE < UTOP ; pn++){
		if ( ( 	(uvpd[PDX(pn*PGSIZE)] & PTE_P) != 0) &&
				( (uvpt[PGNUM(pn*PGSIZE)] & PTE_U) != 0) &&
  800f3c:	f6 c2 01             	test   $0x1,%dl
  800f3f:	0f 84 98 00 00 00    	je     800fdd <fork+0x162>
				( (uvpt[PGNUM(pn*PGSIZE)] & PTE_P) != 0))
		{
		//build experition stack for the child env
			if(pn*PGSIZE == UXSTACKTOP -PGSIZE)
  800f45:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  800f4b:	75 17                	jne    800f64 <fork+0xe9>
				sys_page_alloc(childEid, (void*) (pn*PGSIZE), PTE_U| PTE_W | PTE_P);
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	6a 07                	push   $0x7
  800f52:	68 00 f0 bf ee       	push   $0xeebff000
  800f57:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f5a:	e8 51 fc ff ff       	call   800bb0 <sys_page_alloc>
  800f5f:	83 c4 10             	add    $0x10,%esp
  800f62:	eb 60                	jmp    800fc4 <fork+0x149>
duppage(envid_t envid, unsigned pn)
{
	int r;
	

	pte_t  PTE= uvpt[PGNUM(pn*PGSIZE)];
  800f64:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	int perm = PTE_U|PTE_P;
	if((PTE & PTE_W) || (PTE & PTE_COW))
  800f6b:	25 02 08 00 00       	and    $0x802,%eax
		perm |= PTE_COW;
  800f70:	83 f8 01             	cmp    $0x1,%eax
  800f73:	19 f6                	sbb    %esi,%esi
  800f75:	81 e6 00 f8 ff ff    	and    $0xfffff800,%esi
  800f7b:	81 c6 05 08 00 00    	add    $0x805,%esi
	
	if( (	r =sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), perm)) 
  800f81:	e8 ec fb ff ff       	call   800b72 <sys_getenvid>
  800f86:	83 ec 0c             	sub    $0xc,%esp
  800f89:	56                   	push   %esi
  800f8a:	53                   	push   %ebx
  800f8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f8e:	53                   	push   %ebx
  800f8f:	50                   	push   %eax
  800f90:	e8 5e fc ff ff       	call   800bf3 <sys_page_map>
  800f95:	89 c7                	mov    %eax,%edi
  800f97:	83 c4 20             	add    $0x20,%esp
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	78 2a                	js     800fc8 <fork+0x14d>
						<0)  
		return r;

	if( (	r =sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), perm)) 
  800f9e:	e8 cf fb ff ff       	call   800b72 <sys_getenvid>
  800fa3:	89 c7                	mov    %eax,%edi
  800fa5:	e8 c8 fb ff ff       	call   800b72 <sys_getenvid>
  800faa:	83 ec 0c             	sub    $0xc,%esp
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	57                   	push   %edi
  800fb0:	53                   	push   %ebx
  800fb1:	50                   	push   %eax
  800fb2:	e8 3c fc ff ff       	call   800bf3 <sys_page_map>
  800fb7:	83 c4 20             	add    $0x20,%esp
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	bf 00 00 00 00       	mov    $0x0,%edi
  800fc1:	0f 4e f8             	cmovle %eax,%edi
		//build experition stack for the child env
			if(pn*PGSIZE == UXSTACKTOP -PGSIZE)
				sys_page_alloc(childEid, (void*) (pn*PGSIZE), PTE_U| PTE_W | PTE_P);
			else
				r = duppage(childEid, pn);
			if(r <0)
  800fc4:	85 ff                	test   %edi,%edi
  800fc6:	79 15                	jns    800fdd <fork+0x162>
				panic("fork() is wrong, and the errno is %d\n", r) ;
  800fc8:	57                   	push   %edi
  800fc9:	68 70 19 80 00       	push   $0x801970
  800fce:	68 99 00 00 00       	push   $0x99
  800fd3:	68 f4 17 80 00       	push   $0x8017f4
  800fd8:	e8 b2 01 00 00       	call   80118f <_panic>
  800fdd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	if(r < 0)
		panic("sys_env_set_pgfault_upcall is not right ,and the errno is %d\n", r);
	

	int pn =0;
	for(pn=0; pn*PGSIZE < UTOP ; pn++){
  800fe3:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
  800fe9:	0f 85 1d ff ff ff    	jne    800f0c <fork+0x91>
				r = duppage(childEid, pn);
			if(r <0)
				panic("fork() is wrong, and the errno is %d\n", r) ;
		}
	}
	if (sys_env_set_status(childEid, ENV_RUNNABLE) < 0)
  800fef:	83 ec 08             	sub    $0x8,%esp
  800ff2:	6a 02                	push   $0x2
  800ff4:	ff 75 e0             	pushl  -0x20(%ebp)
  800ff7:	e8 7b fc ff ff       	call   800c77 <sys_env_set_status>
  800ffc:	83 c4 10             	add    $0x10,%esp
  800fff:	85 c0                	test   %eax,%eax
  801001:	79 17                	jns    80101a <fork+0x19f>
		panic("sys_env_set_status");
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 ff 17 80 00       	push   $0x8017ff
  80100b:	68 9d 00 00 00       	push   $0x9d
  801010:	68 f4 17 80 00       	push   $0x8017f4
  801015:	e8 75 01 00 00       	call   80118f <_panic>
	return childEid;
}
  80101a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80101d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801020:	5b                   	pop    %ebx
  801021:	5e                   	pop    %esi
  801022:	5f                   	pop    %edi
  801023:	5d                   	pop    %ebp
  801024:	c3                   	ret    

00801025 <sfork>:

// Challenge!
int
sfork(void)
{
  801025:	55                   	push   %ebp
  801026:	89 e5                	mov    %esp,%ebp
  801028:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80102b:	68 12 18 80 00       	push   $0x801812
  801030:	68 a5 00 00 00       	push   $0xa5
  801035:	68 f4 17 80 00       	push   $0x8017f4
  80103a:	e8 50 01 00 00       	call   80118f <_panic>

0080103f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	56                   	push   %esi
  801043:	53                   	push   %ebx
  801044:	8b 75 08             	mov    0x8(%ebp),%esi
  801047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r =0;
	int a;
	if(pg == 0)
  80104d:	85 c0                	test   %eax,%eax
  80104f:	75 12                	jne    801063 <ipc_recv+0x24>
		r= sys_ipc_recv( (void *)UTOP);
  801051:	83 ec 0c             	sub    $0xc,%esp
  801054:	68 00 00 c0 ee       	push   $0xeec00000
  801059:	e8 c0 fc ff ff       	call   800d1e <sys_ipc_recv>
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	eb 0c                	jmp    80106f <ipc_recv+0x30>
	else
		r = sys_ipc_recv(pg);
  801063:	83 ec 0c             	sub    $0xc,%esp
  801066:	50                   	push   %eax
  801067:	e8 b2 fc ff ff       	call   800d1e <sys_ipc_recv>
  80106c:	83 c4 10             	add    $0x10,%esp
	if(r == 0){
  80106f:	85 c0                	test   %eax,%eax
  801071:	75 1e                	jne    801091 <ipc_recv+0x52>
		if( from_env_store != 0 )
  801073:	85 f6                	test   %esi,%esi
  801075:	74 0a                	je     801081 <ipc_recv+0x42>
			*from_env_store = thisenv->env_ipc_from;
  801077:	a1 04 20 80 00       	mov    0x802004,%eax
  80107c:	8b 40 74             	mov    0x74(%eax),%eax
  80107f:	89 06                	mov    %eax,(%esi)

		if(perm_store != 0 )
  801081:	85 db                	test   %ebx,%ebx
  801083:	74 1e                	je     8010a3 <ipc_recv+0x64>
			*perm_store = thisenv->env_ipc_perm;
  801085:	a1 04 20 80 00       	mov    0x802004,%eax
  80108a:	8b 40 78             	mov    0x78(%eax),%eax
  80108d:	89 03                	mov    %eax,(%ebx)
  80108f:	eb 12                	jmp    8010a3 <ipc_recv+0x64>
	}
	else{
		panic("The ipc_recv is not right, and the errno is %d\n",r);
  801091:	50                   	push   %eax
  801092:	68 98 19 80 00       	push   $0x801998
  801097:	6a 28                	push   $0x28
  801099:	68 14 1a 80 00       	push   $0x801a14
  80109e:	e8 ec 00 00 00       	call   80118f <_panic>

		if(perm_store != 0 )
			*perm_store = 0;
		return r;
	}
	if(thisenv->env_ipc_value == 0)
  8010a3:	a1 04 20 80 00       	mov    0x802004,%eax
  8010a8:	8b 50 70             	mov    0x70(%eax),%edx
  8010ab:	85 d2                	test   %edx,%edx
  8010ad:	75 14                	jne    8010c3 <ipc_recv+0x84>
		cprintf("the value is 0, the envid is %x\n", thisenv->env_id);
  8010af:	8b 40 48             	mov    0x48(%eax),%eax
  8010b2:	83 ec 08             	sub    $0x8,%esp
  8010b5:	50                   	push   %eax
  8010b6:	68 c8 19 80 00       	push   $0x8019c8
  8010bb:	e8 e9 f0 ff ff       	call   8001a9 <cprintf>
  8010c0:	83 c4 10             	add    $0x10,%esp
	return thisenv->env_ipc_value;
  8010c3:	a1 04 20 80 00       	mov    0x802004,%eax
  8010c8:	8b 40 70             	mov    0x70(%eax),%eax
	

	


}
  8010cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010ce:	5b                   	pop    %ebx
  8010cf:	5e                   	pop    %esi
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	57                   	push   %edi
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	83 ec 0c             	sub    $0xc,%esp
  8010db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8010de:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	//panic("ipc_send not implemented");
	
	int r =0;
	while(1){
		if(pg == 0)
  8010e1:	85 f6                	test   %esi,%esi
  8010e3:	75 18                	jne    8010fd <ipc_send+0x2b>
			r=sys_ipc_try_send(to_env,  val, (void*) UTOP,  perm);
  8010e5:	ff 75 14             	pushl  0x14(%ebp)
  8010e8:	68 00 00 c0 ee       	push   $0xeec00000
  8010ed:	ff 75 0c             	pushl  0xc(%ebp)
  8010f0:	57                   	push   %edi
  8010f1:	e8 05 fc ff ff       	call   800cfb <sys_ipc_try_send>
  8010f6:	89 c3                	mov    %eax,%ebx
  8010f8:	83 c4 10             	add    $0x10,%esp
  8010fb:	eb 12                	jmp    80110f <ipc_send+0x3d>
		else
			r = sys_ipc_try_send(to_env,  val, pg,  perm);
  8010fd:	ff 75 14             	pushl  0x14(%ebp)
  801100:	56                   	push   %esi
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	57                   	push   %edi
  801105:	e8 f1 fb ff ff       	call   800cfb <sys_ipc_try_send>
  80110a:	89 c3                	mov    %eax,%ebx
  80110c:	83 c4 10             	add    $0x10,%esp

		if(r <0 && r != -E_IPC_NOT_RECV){
  80110f:	89 d8                	mov    %ebx,%eax
  801111:	c1 e8 1f             	shr    $0x1f,%eax
  801114:	84 c0                	test   %al,%al
  801116:	74 2a                	je     801142 <ipc_send+0x70>
  801118:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80111b:	74 25                	je     801142 <ipc_send+0x70>
			cprintf("the envid is %x\n", sys_getenvid());
  80111d:	e8 50 fa ff ff       	call   800b72 <sys_getenvid>
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	50                   	push   %eax
  801126:	68 1e 1a 80 00       	push   $0x801a1e
  80112b:	e8 79 f0 ff ff       	call   8001a9 <cprintf>
			panic("ipc_send is error, and the errno is %d\n", r);
  801130:	53                   	push   %ebx
  801131:	68 ec 19 80 00       	push   $0x8019ec
  801136:	6a 53                	push   $0x53
  801138:	68 14 1a 80 00       	push   $0x801a14
  80113d:	e8 4d 00 00 00       	call   80118f <_panic>
		}
		else if(r == -E_IPC_NOT_RECV)
  801142:	83 fb f8             	cmp    $0xfffffff8,%ebx
  801145:	75 07                	jne    80114e <ipc_send+0x7c>
			sys_yield();
  801147:	e8 45 fa ff ff       	call   800b91 <sys_yield>
		else break;
	}
  80114c:	eb 93                	jmp    8010e1 <ipc_send+0xf>
	



}
  80114e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801151:	5b                   	pop    %ebx
  801152:	5e                   	pop    %esi
  801153:	5f                   	pop    %edi
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    

00801156 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80115c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801161:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801164:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80116a:	8b 52 50             	mov    0x50(%edx),%edx
  80116d:	39 ca                	cmp    %ecx,%edx
  80116f:	75 0d                	jne    80117e <ipc_find_env+0x28>
			return envs[i].env_id;
  801171:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801174:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801179:	8b 40 48             	mov    0x48(%eax),%eax
  80117c:	eb 0f                	jmp    80118d <ipc_find_env+0x37>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80117e:	83 c0 01             	add    $0x1,%eax
  801181:	3d 00 04 00 00       	cmp    $0x400,%eax
  801186:	75 d9                	jne    801161 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801188:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118d:	5d                   	pop    %ebp
  80118e:	c3                   	ret    

0080118f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	56                   	push   %esi
  801193:	53                   	push   %ebx
	va_list ap;

	va_start(ap, fmt);
  801194:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801197:	8b 35 00 20 80 00    	mov    0x802000,%esi
  80119d:	e8 d0 f9 ff ff       	call   800b72 <sys_getenvid>
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	56                   	push   %esi
  8011ac:	50                   	push   %eax
  8011ad:	68 30 1a 80 00       	push   $0x801a30
  8011b2:	e8 f2 ef ff ff       	call   8001a9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8011b7:	83 c4 18             	add    $0x18,%esp
  8011ba:	53                   	push   %ebx
  8011bb:	ff 75 10             	pushl  0x10(%ebp)
  8011be:	e8 95 ef ff ff       	call   800158 <vcprintf>
	cprintf("\n");
  8011c3:	c7 04 24 47 15 80 00 	movl   $0x801547,(%esp)
  8011ca:	e8 da ef ff ff       	call   8001a9 <cprintf>
  8011cf:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8011d2:	cc                   	int3   
  8011d3:	eb fd                	jmp    8011d2 <_panic+0x43>

008011d5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8011d5:	55                   	push   %ebp
  8011d6:	89 e5                	mov    %esp,%ebp
  8011d8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8011db:	83 3d 08 20 80 00 00 	cmpl   $0x0,0x802008
  8011e2:	75 31                	jne    801215 <set_pgfault_handler+0x40>
		// First time through!
		// LAB 4: Your code here.
		void* addr = (void*) (UXSTACKTOP-PGSIZE);
		r=sys_page_alloc(thisenv->env_id, addr, PTE_W|PTE_U|PTE_P);
  8011e4:	a1 04 20 80 00       	mov    0x802004,%eax
  8011e9:	8b 40 48             	mov    0x48(%eax),%eax
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	6a 07                	push   $0x7
  8011f1:	68 00 f0 bf ee       	push   $0xeebff000
  8011f6:	50                   	push   %eax
  8011f7:	e8 b4 f9 ff ff       	call   800bb0 <sys_page_alloc>
		if( r < 0)
  8011fc:	83 c4 10             	add    $0x10,%esp
  8011ff:	85 c0                	test   %eax,%eax
  801201:	79 12                	jns    801215 <set_pgfault_handler+0x40>
			panic("No memory for the UxStack, the mistake is %d\n",r);
  801203:	50                   	push   %eax
  801204:	68 54 1a 80 00       	push   $0x801a54
  801209:	6a 23                	push   $0x23
  80120b:	68 b0 1a 80 00       	push   $0x801ab0
  801210:	e8 7a ff ff ff       	call   80118f <_panic>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	a3 08 20 80 00       	mov    %eax,0x802008
	if(( r= sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall))<0)
  80121d:	e8 50 f9 ff ff       	call   800b72 <sys_getenvid>
  801222:	83 ec 08             	sub    $0x8,%esp
  801225:	68 4b 12 80 00       	push   $0x80124b
  80122a:	50                   	push   %eax
  80122b:	e8 89 fa ff ff       	call   800cb9 <sys_env_set_pgfault_upcall>
  801230:	83 c4 10             	add    $0x10,%esp
  801233:	85 c0                	test   %eax,%eax
  801235:	79 12                	jns    801249 <set_pgfault_handler+0x74>
		panic("sys_env_set_pgfault_upcall is not right %d\n", r);
  801237:	50                   	push   %eax
  801238:	68 84 1a 80 00       	push   $0x801a84
  80123d:	6a 2a                	push   $0x2a
  80123f:	68 b0 1a 80 00       	push   $0x801ab0
  801244:	e8 46 ff ff ff       	call   80118f <_panic>


}
  801249:	c9                   	leave  
  80124a:	c3                   	ret    

0080124b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80124b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80124c:	a1 08 20 80 00       	mov    0x802008,%eax
	call *%eax
  801251:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801253:	83 c4 04             	add    $0x4,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	//	trap-eip -> eax
		movl 0x28(%esp), %eax
  801256:	8b 44 24 28          	mov    0x28(%esp),%eax
	//	trap-ebp-> ebx		
		movl 0x10(%esp), %ebx
  80125a:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	//  trap->esp -> ecx 
		movl 0x30(%esp), %ecx
  80125e:	8b 4c 24 30          	mov    0x30(%esp),%ecx

		movl %eax, -0x4(%ecx)
  801262:	89 41 fc             	mov    %eax,-0x4(%ecx)
		movl %ebx, -0x8(%ecx)
  801265:	89 59 f8             	mov    %ebx,-0x8(%ecx)

		leal -0x8(%ecx), %ebp
  801268:	8d 69 f8             	lea    -0x8(%ecx),%ebp

		movl 0x8(%esp), %edi
  80126b:	8b 7c 24 08          	mov    0x8(%esp),%edi
		movl 0xc(%esp),	%esi
  80126f:	8b 74 24 0c          	mov    0xc(%esp),%esi
		movl 0x18(%esp),%ebx
  801273:	8b 5c 24 18          	mov    0x18(%esp),%ebx
		movl 0x1c(%esp),%edx
  801277:	8b 54 24 1c          	mov    0x1c(%esp),%edx
		movl 0x20(%esp),%ecx
  80127b:	8b 4c 24 20          	mov    0x20(%esp),%ecx
		movl 0x24(%esp),%eax
  80127f:	8b 44 24 24          	mov    0x24(%esp),%eax

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
		leal 0x2c(%esp), %esp
  801283:	8d 64 24 2c          	lea    0x2c(%esp),%esp
		popf
  801287:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
		leave
  801288:	c9                   	leave  
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801289:	c3                   	ret    
  80128a:	66 90                	xchg   %ax,%ax
  80128c:	66 90                	xchg   %ax,%ax
  80128e:	66 90                	xchg   %ax,%ax

00801290 <__udivdi3>:
  801290:	55                   	push   %ebp
  801291:	57                   	push   %edi
  801292:	56                   	push   %esi
  801293:	53                   	push   %ebx
  801294:	83 ec 1c             	sub    $0x1c,%esp
  801297:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80129b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80129f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8012a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8012a7:	85 f6                	test   %esi,%esi
  8012a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012ad:	89 ca                	mov    %ecx,%edx
  8012af:	89 f8                	mov    %edi,%eax
  8012b1:	75 3d                	jne    8012f0 <__udivdi3+0x60>
  8012b3:	39 cf                	cmp    %ecx,%edi
  8012b5:	0f 87 c5 00 00 00    	ja     801380 <__udivdi3+0xf0>
  8012bb:	85 ff                	test   %edi,%edi
  8012bd:	89 fd                	mov    %edi,%ebp
  8012bf:	75 0b                	jne    8012cc <__udivdi3+0x3c>
  8012c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8012c6:	31 d2                	xor    %edx,%edx
  8012c8:	f7 f7                	div    %edi
  8012ca:	89 c5                	mov    %eax,%ebp
  8012cc:	89 c8                	mov    %ecx,%eax
  8012ce:	31 d2                	xor    %edx,%edx
  8012d0:	f7 f5                	div    %ebp
  8012d2:	89 c1                	mov    %eax,%ecx
  8012d4:	89 d8                	mov    %ebx,%eax
  8012d6:	89 cf                	mov    %ecx,%edi
  8012d8:	f7 f5                	div    %ebp
  8012da:	89 c3                	mov    %eax,%ebx
  8012dc:	89 d8                	mov    %ebx,%eax
  8012de:	89 fa                	mov    %edi,%edx
  8012e0:	83 c4 1c             	add    $0x1c,%esp
  8012e3:	5b                   	pop    %ebx
  8012e4:	5e                   	pop    %esi
  8012e5:	5f                   	pop    %edi
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    
  8012e8:	90                   	nop
  8012e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012f0:	39 ce                	cmp    %ecx,%esi
  8012f2:	77 74                	ja     801368 <__udivdi3+0xd8>
  8012f4:	0f bd fe             	bsr    %esi,%edi
  8012f7:	83 f7 1f             	xor    $0x1f,%edi
  8012fa:	0f 84 98 00 00 00    	je     801398 <__udivdi3+0x108>
  801300:	bb 20 00 00 00       	mov    $0x20,%ebx
  801305:	89 f9                	mov    %edi,%ecx
  801307:	89 c5                	mov    %eax,%ebp
  801309:	29 fb                	sub    %edi,%ebx
  80130b:	d3 e6                	shl    %cl,%esi
  80130d:	89 d9                	mov    %ebx,%ecx
  80130f:	d3 ed                	shr    %cl,%ebp
  801311:	89 f9                	mov    %edi,%ecx
  801313:	d3 e0                	shl    %cl,%eax
  801315:	09 ee                	or     %ebp,%esi
  801317:	89 d9                	mov    %ebx,%ecx
  801319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80131d:	89 d5                	mov    %edx,%ebp
  80131f:	8b 44 24 08          	mov    0x8(%esp),%eax
  801323:	d3 ed                	shr    %cl,%ebp
  801325:	89 f9                	mov    %edi,%ecx
  801327:	d3 e2                	shl    %cl,%edx
  801329:	89 d9                	mov    %ebx,%ecx
  80132b:	d3 e8                	shr    %cl,%eax
  80132d:	09 c2                	or     %eax,%edx
  80132f:	89 d0                	mov    %edx,%eax
  801331:	89 ea                	mov    %ebp,%edx
  801333:	f7 f6                	div    %esi
  801335:	89 d5                	mov    %edx,%ebp
  801337:	89 c3                	mov    %eax,%ebx
  801339:	f7 64 24 0c          	mull   0xc(%esp)
  80133d:	39 d5                	cmp    %edx,%ebp
  80133f:	72 10                	jb     801351 <__udivdi3+0xc1>
  801341:	8b 74 24 08          	mov    0x8(%esp),%esi
  801345:	89 f9                	mov    %edi,%ecx
  801347:	d3 e6                	shl    %cl,%esi
  801349:	39 c6                	cmp    %eax,%esi
  80134b:	73 07                	jae    801354 <__udivdi3+0xc4>
  80134d:	39 d5                	cmp    %edx,%ebp
  80134f:	75 03                	jne    801354 <__udivdi3+0xc4>
  801351:	83 eb 01             	sub    $0x1,%ebx
  801354:	31 ff                	xor    %edi,%edi
  801356:	89 d8                	mov    %ebx,%eax
  801358:	89 fa                	mov    %edi,%edx
  80135a:	83 c4 1c             	add    $0x1c,%esp
  80135d:	5b                   	pop    %ebx
  80135e:	5e                   	pop    %esi
  80135f:	5f                   	pop    %edi
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    
  801362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801368:	31 ff                	xor    %edi,%edi
  80136a:	31 db                	xor    %ebx,%ebx
  80136c:	89 d8                	mov    %ebx,%eax
  80136e:	89 fa                	mov    %edi,%edx
  801370:	83 c4 1c             	add    $0x1c,%esp
  801373:	5b                   	pop    %ebx
  801374:	5e                   	pop    %esi
  801375:	5f                   	pop    %edi
  801376:	5d                   	pop    %ebp
  801377:	c3                   	ret    
  801378:	90                   	nop
  801379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801380:	89 d8                	mov    %ebx,%eax
  801382:	f7 f7                	div    %edi
  801384:	31 ff                	xor    %edi,%edi
  801386:	89 c3                	mov    %eax,%ebx
  801388:	89 d8                	mov    %ebx,%eax
  80138a:	89 fa                	mov    %edi,%edx
  80138c:	83 c4 1c             	add    $0x1c,%esp
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5f                   	pop    %edi
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    
  801394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801398:	39 ce                	cmp    %ecx,%esi
  80139a:	72 0c                	jb     8013a8 <__udivdi3+0x118>
  80139c:	31 db                	xor    %ebx,%ebx
  80139e:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8013a2:	0f 87 34 ff ff ff    	ja     8012dc <__udivdi3+0x4c>
  8013a8:	bb 01 00 00 00       	mov    $0x1,%ebx
  8013ad:	e9 2a ff ff ff       	jmp    8012dc <__udivdi3+0x4c>
  8013b2:	66 90                	xchg   %ax,%ax
  8013b4:	66 90                	xchg   %ax,%ax
  8013b6:	66 90                	xchg   %ax,%ax
  8013b8:	66 90                	xchg   %ax,%ax
  8013ba:	66 90                	xchg   %ax,%ax
  8013bc:	66 90                	xchg   %ax,%ax
  8013be:	66 90                	xchg   %ax,%ax

008013c0 <__umoddi3>:
  8013c0:	55                   	push   %ebp
  8013c1:	57                   	push   %edi
  8013c2:	56                   	push   %esi
  8013c3:	53                   	push   %ebx
  8013c4:	83 ec 1c             	sub    $0x1c,%esp
  8013c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8013cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8013cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8013d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8013d7:	85 d2                	test   %edx,%edx
  8013d9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8013dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013e1:	89 f3                	mov    %esi,%ebx
  8013e3:	89 3c 24             	mov    %edi,(%esp)
  8013e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013ea:	75 1c                	jne    801408 <__umoddi3+0x48>
  8013ec:	39 f7                	cmp    %esi,%edi
  8013ee:	76 50                	jbe    801440 <__umoddi3+0x80>
  8013f0:	89 c8                	mov    %ecx,%eax
  8013f2:	89 f2                	mov    %esi,%edx
  8013f4:	f7 f7                	div    %edi
  8013f6:	89 d0                	mov    %edx,%eax
  8013f8:	31 d2                	xor    %edx,%edx
  8013fa:	83 c4 1c             	add    $0x1c,%esp
  8013fd:	5b                   	pop    %ebx
  8013fe:	5e                   	pop    %esi
  8013ff:	5f                   	pop    %edi
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    
  801402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801408:	39 f2                	cmp    %esi,%edx
  80140a:	89 d0                	mov    %edx,%eax
  80140c:	77 52                	ja     801460 <__umoddi3+0xa0>
  80140e:	0f bd ea             	bsr    %edx,%ebp
  801411:	83 f5 1f             	xor    $0x1f,%ebp
  801414:	75 5a                	jne    801470 <__umoddi3+0xb0>
  801416:	3b 54 24 04          	cmp    0x4(%esp),%edx
  80141a:	0f 82 e0 00 00 00    	jb     801500 <__umoddi3+0x140>
  801420:	39 0c 24             	cmp    %ecx,(%esp)
  801423:	0f 86 d7 00 00 00    	jbe    801500 <__umoddi3+0x140>
  801429:	8b 44 24 08          	mov    0x8(%esp),%eax
  80142d:	8b 54 24 04          	mov    0x4(%esp),%edx
  801431:	83 c4 1c             	add    $0x1c,%esp
  801434:	5b                   	pop    %ebx
  801435:	5e                   	pop    %esi
  801436:	5f                   	pop    %edi
  801437:	5d                   	pop    %ebp
  801438:	c3                   	ret    
  801439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801440:	85 ff                	test   %edi,%edi
  801442:	89 fd                	mov    %edi,%ebp
  801444:	75 0b                	jne    801451 <__umoddi3+0x91>
  801446:	b8 01 00 00 00       	mov    $0x1,%eax
  80144b:	31 d2                	xor    %edx,%edx
  80144d:	f7 f7                	div    %edi
  80144f:	89 c5                	mov    %eax,%ebp
  801451:	89 f0                	mov    %esi,%eax
  801453:	31 d2                	xor    %edx,%edx
  801455:	f7 f5                	div    %ebp
  801457:	89 c8                	mov    %ecx,%eax
  801459:	f7 f5                	div    %ebp
  80145b:	89 d0                	mov    %edx,%eax
  80145d:	eb 99                	jmp    8013f8 <__umoddi3+0x38>
  80145f:	90                   	nop
  801460:	89 c8                	mov    %ecx,%eax
  801462:	89 f2                	mov    %esi,%edx
  801464:	83 c4 1c             	add    $0x1c,%esp
  801467:	5b                   	pop    %ebx
  801468:	5e                   	pop    %esi
  801469:	5f                   	pop    %edi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    
  80146c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801470:	8b 34 24             	mov    (%esp),%esi
  801473:	bf 20 00 00 00       	mov    $0x20,%edi
  801478:	89 e9                	mov    %ebp,%ecx
  80147a:	29 ef                	sub    %ebp,%edi
  80147c:	d3 e0                	shl    %cl,%eax
  80147e:	89 f9                	mov    %edi,%ecx
  801480:	89 f2                	mov    %esi,%edx
  801482:	d3 ea                	shr    %cl,%edx
  801484:	89 e9                	mov    %ebp,%ecx
  801486:	09 c2                	or     %eax,%edx
  801488:	89 d8                	mov    %ebx,%eax
  80148a:	89 14 24             	mov    %edx,(%esp)
  80148d:	89 f2                	mov    %esi,%edx
  80148f:	d3 e2                	shl    %cl,%edx
  801491:	89 f9                	mov    %edi,%ecx
  801493:	89 54 24 04          	mov    %edx,0x4(%esp)
  801497:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80149b:	d3 e8                	shr    %cl,%eax
  80149d:	89 e9                	mov    %ebp,%ecx
  80149f:	89 c6                	mov    %eax,%esi
  8014a1:	d3 e3                	shl    %cl,%ebx
  8014a3:	89 f9                	mov    %edi,%ecx
  8014a5:	89 d0                	mov    %edx,%eax
  8014a7:	d3 e8                	shr    %cl,%eax
  8014a9:	89 e9                	mov    %ebp,%ecx
  8014ab:	09 d8                	or     %ebx,%eax
  8014ad:	89 d3                	mov    %edx,%ebx
  8014af:	89 f2                	mov    %esi,%edx
  8014b1:	f7 34 24             	divl   (%esp)
  8014b4:	89 d6                	mov    %edx,%esi
  8014b6:	d3 e3                	shl    %cl,%ebx
  8014b8:	f7 64 24 04          	mull   0x4(%esp)
  8014bc:	39 d6                	cmp    %edx,%esi
  8014be:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014c2:	89 d1                	mov    %edx,%ecx
  8014c4:	89 c3                	mov    %eax,%ebx
  8014c6:	72 08                	jb     8014d0 <__umoddi3+0x110>
  8014c8:	75 11                	jne    8014db <__umoddi3+0x11b>
  8014ca:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8014ce:	73 0b                	jae    8014db <__umoddi3+0x11b>
  8014d0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8014d4:	1b 14 24             	sbb    (%esp),%edx
  8014d7:	89 d1                	mov    %edx,%ecx
  8014d9:	89 c3                	mov    %eax,%ebx
  8014db:	8b 54 24 08          	mov    0x8(%esp),%edx
  8014df:	29 da                	sub    %ebx,%edx
  8014e1:	19 ce                	sbb    %ecx,%esi
  8014e3:	89 f9                	mov    %edi,%ecx
  8014e5:	89 f0                	mov    %esi,%eax
  8014e7:	d3 e0                	shl    %cl,%eax
  8014e9:	89 e9                	mov    %ebp,%ecx
  8014eb:	d3 ea                	shr    %cl,%edx
  8014ed:	89 e9                	mov    %ebp,%ecx
  8014ef:	d3 ee                	shr    %cl,%esi
  8014f1:	09 d0                	or     %edx,%eax
  8014f3:	89 f2                	mov    %esi,%edx
  8014f5:	83 c4 1c             	add    $0x1c,%esp
  8014f8:	5b                   	pop    %ebx
  8014f9:	5e                   	pop    %esi
  8014fa:	5f                   	pop    %edi
  8014fb:	5d                   	pop    %ebp
  8014fc:	c3                   	ret    
  8014fd:	8d 76 00             	lea    0x0(%esi),%esi
  801500:	29 f9                	sub    %edi,%ecx
  801502:	19 d6                	sbb    %edx,%esi
  801504:	89 74 24 04          	mov    %esi,0x4(%esp)
  801508:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80150c:	e9 18 ff ff ff       	jmp    801429 <__umoddi3+0x69>
