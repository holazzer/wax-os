
build/kernel.bin:     file format elf32-i386


Disassembly of section .text:

c0001500 <main>:
c0001500:	8d 4c 24 04          	lea    0x4(%esp),%ecx
c0001504:	83 e4 f0             	and    $0xfffffff0,%esp
c0001507:	ff 71 fc             	pushl  -0x4(%ecx)
c000150a:	55                   	push   %ebp
c000150b:	89 e5                	mov    %esp,%ebp
c000150d:	53                   	push   %ebx
c000150e:	51                   	push   %ecx
c000150f:	e8 30 00 00 00       	call   c0001544 <__x86.get_pc_thunk.bx>
c0001514:	81 c3 ec 1a 00 00    	add    $0x1aec,%ebx
c000151a:	83 ec 0c             	sub    $0xc,%esp
c000151d:	68 90 01 00 00       	push   $0x190
c0001522:	e8 84 06 00 00       	call   c0001bab <my_set_cursor>
c0001527:	83 c4 10             	add    $0x10,%esp
c000152a:	83 ec 0c             	sub    $0xc,%esp
c000152d:	8d 83 38 ec ff ff    	lea    -0x13c8(%ebx),%eax
c0001533:	50                   	push   %eax
c0001534:	e8 54 06 00 00       	call   c0001b8d <put_str>
c0001539:	83 c4 10             	add    $0x10,%esp
c000153c:	e8 07 00 00 00       	call   c0001548 <init_all>
c0001541:	fb                   	sti    
c0001542:	eb fe                	jmp    c0001542 <main+0x42>

c0001544 <__x86.get_pc_thunk.bx>:
c0001544:	8b 1c 24             	mov    (%esp),%ebx
c0001547:	c3                   	ret    

c0001548 <init_all>:
c0001548:	55                   	push   %ebp
c0001549:	89 e5                	mov    %esp,%ebp
c000154b:	53                   	push   %ebx
c000154c:	83 ec 04             	sub    $0x4,%esp
c000154f:	e8 f0 ff ff ff       	call   c0001544 <__x86.get_pc_thunk.bx>
c0001554:	81 c3 ac 1a 00 00    	add    $0x1aac,%ebx
c000155a:	83 ec 0c             	sub    $0xc,%esp
c000155d:	8d 83 45 ec ff ff    	lea    -0x13bb(%ebx),%eax
c0001563:	50                   	push   %eax
c0001564:	e8 24 06 00 00       	call   c0001b8d <put_str>
c0001569:	83 c4 10             	add    $0x10,%esp
c000156c:	e8 94 01 00 00       	call   c0001705 <idt_init>
c0001571:	90                   	nop
c0001572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0001575:	c9                   	leave  
c0001576:	c3                   	ret    

c0001577 <outb>:
c0001577:	55                   	push   %ebp
c0001578:	89 e5                	mov    %esp,%ebp
c000157a:	83 ec 08             	sub    $0x8,%esp
c000157d:	e8 fe 01 00 00       	call   c0001780 <__x86.get_pc_thunk.ax>
c0001582:	05 7e 1a 00 00       	add    $0x1a7e,%eax
c0001587:	8b 55 08             	mov    0x8(%ebp),%edx
c000158a:	8b 45 0c             	mov    0xc(%ebp),%eax
c000158d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
c0001591:	88 45 f8             	mov    %al,-0x8(%ebp)
c0001594:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
c0001598:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
c000159c:	ee                   	out    %al,(%dx)
c000159d:	90                   	nop
c000159e:	c9                   	leave  
c000159f:	c3                   	ret    

c00015a0 <make_idt_desc>:
c00015a0:	55                   	push   %ebp
c00015a1:	89 e5                	mov    %esp,%ebp
c00015a3:	83 ec 04             	sub    $0x4,%esp
c00015a6:	e8 d5 01 00 00       	call   c0001780 <__x86.get_pc_thunk.ax>
c00015ab:	05 55 1a 00 00       	add    $0x1a55,%eax
c00015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c00015b3:	88 45 fc             	mov    %al,-0x4(%ebp)
c00015b6:	8b 45 10             	mov    0x10(%ebp),%eax
c00015b9:	89 c2                	mov    %eax,%edx
c00015bb:	8b 45 08             	mov    0x8(%ebp),%eax
c00015be:	66 89 10             	mov    %dx,(%eax)
c00015c1:	8b 45 10             	mov    0x10(%ebp),%eax
c00015c4:	c1 e8 10             	shr    $0x10,%eax
c00015c7:	89 c2                	mov    %eax,%edx
c00015c9:	8b 45 08             	mov    0x8(%ebp),%eax
c00015cc:	66 89 50 06          	mov    %dx,0x6(%eax)
c00015d0:	8b 45 08             	mov    0x8(%ebp),%eax
c00015d3:	c6 40 04 00          	movb   $0x0,0x4(%eax)
c00015d7:	8b 45 08             	mov    0x8(%ebp),%eax
c00015da:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
c00015de:	88 50 05             	mov    %dl,0x5(%eax)
c00015e1:	90                   	nop
c00015e2:	c9                   	leave  
c00015e3:	c3                   	ret    

c00015e4 <pic_init>:
c00015e4:	55                   	push   %ebp
c00015e5:	89 e5                	mov    %esp,%ebp
c00015e7:	53                   	push   %ebx
c00015e8:	83 ec 04             	sub    $0x4,%esp
c00015eb:	e8 54 ff ff ff       	call   c0001544 <__x86.get_pc_thunk.bx>
c00015f0:	81 c3 10 1a 00 00    	add    $0x1a10,%ebx
c00015f6:	6a 11                	push   $0x11
c00015f8:	6a 20                	push   $0x20
c00015fa:	e8 78 ff ff ff       	call   c0001577 <outb>
c00015ff:	83 c4 08             	add    $0x8,%esp
c0001602:	6a 20                	push   $0x20
c0001604:	6a 21                	push   $0x21
c0001606:	e8 6c ff ff ff       	call   c0001577 <outb>
c000160b:	83 c4 08             	add    $0x8,%esp
c000160e:	6a 04                	push   $0x4
c0001610:	6a 21                	push   $0x21
c0001612:	e8 60 ff ff ff       	call   c0001577 <outb>
c0001617:	83 c4 08             	add    $0x8,%esp
c000161a:	6a 01                	push   $0x1
c000161c:	6a 21                	push   $0x21
c000161e:	e8 54 ff ff ff       	call   c0001577 <outb>
c0001623:	83 c4 08             	add    $0x8,%esp
c0001626:	6a 11                	push   $0x11
c0001628:	68 a0 00 00 00       	push   $0xa0
c000162d:	e8 45 ff ff ff       	call   c0001577 <outb>
c0001632:	83 c4 08             	add    $0x8,%esp
c0001635:	6a 28                	push   $0x28
c0001637:	68 a1 00 00 00       	push   $0xa1
c000163c:	e8 36 ff ff ff       	call   c0001577 <outb>
c0001641:	83 c4 08             	add    $0x8,%esp
c0001644:	6a 02                	push   $0x2
c0001646:	68 a1 00 00 00       	push   $0xa1
c000164b:	e8 27 ff ff ff       	call   c0001577 <outb>
c0001650:	83 c4 08             	add    $0x8,%esp
c0001653:	6a 01                	push   $0x1
c0001655:	68 a1 00 00 00       	push   $0xa1
c000165a:	e8 18 ff ff ff       	call   c0001577 <outb>
c000165f:	83 c4 08             	add    $0x8,%esp
c0001662:	68 fe 00 00 00       	push   $0xfe
c0001667:	6a 21                	push   $0x21
c0001669:	e8 09 ff ff ff       	call   c0001577 <outb>
c000166e:	83 c4 08             	add    $0x8,%esp
c0001671:	68 ff 00 00 00       	push   $0xff
c0001676:	68 a1 00 00 00       	push   $0xa1
c000167b:	e8 f7 fe ff ff       	call   c0001577 <outb>
c0001680:	83 c4 08             	add    $0x8,%esp
c0001683:	83 ec 0c             	sub    $0xc,%esp
c0001686:	8d 83 4f ec ff ff    	lea    -0x13b1(%ebx),%eax
c000168c:	50                   	push   %eax
c000168d:	e8 fb 04 00 00       	call   c0001b8d <put_str>
c0001692:	83 c4 10             	add    $0x10,%esp
c0001695:	90                   	nop
c0001696:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0001699:	c9                   	leave  
c000169a:	c3                   	ret    

c000169b <idt_desc_init>:
c000169b:	55                   	push   %ebp
c000169c:	89 e5                	mov    %esp,%ebp
c000169e:	53                   	push   %ebx
c000169f:	83 ec 14             	sub    $0x14,%esp
c00016a2:	e8 9d fe ff ff       	call   c0001544 <__x86.get_pc_thunk.bx>
c00016a7:	81 c3 59 19 00 00    	add    $0x1959,%ebx
c00016ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c00016b4:	eb 31                	jmp    c00016e7 <idt_desc_init+0x4c>
c00016b6:	c7 c0 1d 30 00 c0    	mov    $0xc000301d,%eax
c00016bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c00016bf:	8b 04 90             	mov    (%eax,%edx,4),%eax
c00016c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c00016c5:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
c00016cc:	8d 93 c0 00 00 00    	lea    0xc0(%ebx),%edx
c00016d2:	01 ca                	add    %ecx,%edx
c00016d4:	50                   	push   %eax
c00016d5:	68 8e 00 00 00       	push   $0x8e
c00016da:	52                   	push   %edx
c00016db:	e8 c0 fe ff ff       	call   c00015a0 <make_idt_desc>
c00016e0:	83 c4 0c             	add    $0xc,%esp
c00016e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c00016e7:	83 7d f4 20          	cmpl   $0x20,-0xc(%ebp)
c00016eb:	7e c9                	jle    c00016b6 <idt_desc_init+0x1b>
c00016ed:	83 ec 0c             	sub    $0xc,%esp
c00016f0:	8d 83 62 ec ff ff    	lea    -0x139e(%ebx),%eax
c00016f6:	50                   	push   %eax
c00016f7:	e8 91 04 00 00       	call   c0001b8d <put_str>
c00016fc:	83 c4 10             	add    $0x10,%esp
c00016ff:	90                   	nop
c0001700:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0001703:	c9                   	leave  
c0001704:	c3                   	ret     ; 回到第200行，<idt_init>的call

c0001705 <idt_init>:
c0001705:	55                   	push   %ebp
c0001706:	89 e5                	mov    %esp,%ebp
c0001708:	57                   	push   %edi
c0001709:	56                   	push   %esi
c000170a:	53                   	push   %ebx
c000170b:	83 ec 1c             	sub    $0x1c,%esp
c000170e:	e8 31 fe ff ff       	call   c0001544 <__x86.get_pc_thunk.bx>
c0001713:	81 c3 ed 18 00 00    	add    $0x18ed,%ebx
c0001719:	83 ec 0c             	sub    $0xc,%esp
c000171c:	8d 83 7a ec ff ff    	lea    -0x1386(%ebx),%eax
c0001722:	50                   	push   %eax
c0001723:	e8 65 04 00 00       	call   c0001b8d <put_str>
c0001728:	83 c4 10             	add    $0x10,%esp
c000172b:	e8 6b ff ff ff       	call   c000169b <idt_desc_init>
c0001730:	e8 af fe ff ff       	call   c00015e4 <pic_init>
c0001735:	8d 83 c0 00 00 00    	lea    0xc0(%ebx),%eax
c000173b:	ba 00 00 00 00       	mov    $0x0,%edx
c0001740:	0f a4 c2 10          	shld   $0x10,%eax,%edx
c0001744:	c1 e0 10             	shl    $0x10,%eax
c0001747:	89 d1                	mov    %edx,%ecx
c0001749:	89 c2                	mov    %eax,%edx
c000174b:	89 d0                	mov    %edx,%eax
c000174d:	0d 07 01 00 00       	or     $0x107,%eax
c0001752:	89 c6                	mov    %eax,%esi
c0001754:	89 c8                	mov    %ecx,%eax
c0001756:	80 cc 00             	or     $0x0,%ah
c0001759:	89 c7                	mov    %eax,%edi
c000175b:	89 75 e0             	mov    %esi,-0x20(%ebp)
c000175e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
c0001761:	0f 01 5d e0          	lidtl  -0x20(%ebp)
c0001765:	83 ec 0c             	sub    $0xc,%esp
c0001768:	8d 83 8a ec ff ff    	lea    -0x1376(%ebx),%eax
c000176e:	50                   	push   %eax
c000176f:	e8 19 04 00 00       	call   c0001b8d <put_str>
c0001774:	83 c4 10             	add    $0x10,%esp
c0001777:	90                   	nop
c0001778:	8d 65 f4             	lea    -0xc(%ebp),%esp
c000177b:	5b                   	pop    %ebx
c000177c:	5e                   	pop    %esi
c000177d:	5f                   	pop    %edi
c000177e:	5d                   	pop    %ebp
c000177f:	c3                   	ret    

c0001780 <__x86.get_pc_thunk.ax>:
c0001780:	8b 04 24             	mov    (%esp),%eax
c0001783:	c3                   	ret    
c0001784:	66 90                	xchg   %ax,%ax
c0001786:	66 90                	xchg   %ax,%ax
c0001788:	66 90                	xchg   %ax,%ax
c000178a:	66 90                	xchg   %ax,%ax
c000178c:	66 90                	xchg   %ax,%ax
c000178e:	66 90                	xchg   %ax,%ax

c0001790 <intr0x00entry>:
c0001790:	6a 00                	push   $0x0
c0001792:	68 0c 30 00 c0       	push   $0xc000300c
c0001797:	e8 f1 03 00 00       	call   c0001b8d <put_str>
c000179c:	83 c4 04             	add    $0x4,%esp
c000179f:	b0 20                	mov    $0x20,%al
c00017a1:	e6 a0                	out    %al,$0xa0
c00017a3:	e6 20                	out    %al,$0x20
c00017a5:	83 c4 04             	add    $0x4,%esp
c00017a8:	cf                   	iret   

c00017a9 <intr0x01entry>:
c00017a9:	6a 00                	push   $0x0
c00017ab:	68 0c 30 00 c0       	push   $0xc000300c
c00017b0:	e8 d8 03 00 00       	call   c0001b8d <put_str>
c00017b5:	83 c4 04             	add    $0x4,%esp
c00017b8:	b0 20                	mov    $0x20,%al
c00017ba:	e6 a0                	out    %al,$0xa0
c00017bc:	e6 20                	out    %al,$0x20
c00017be:	83 c4 04             	add    $0x4,%esp
c00017c1:	cf                   	iret   

c00017c2 <intr0x02entry>:
c00017c2:	6a 00                	push   $0x0
c00017c4:	68 0c 30 00 c0       	push   $0xc000300c
c00017c9:	e8 bf 03 00 00       	call   c0001b8d <put_str>
c00017ce:	83 c4 04             	add    $0x4,%esp
c00017d1:	b0 20                	mov    $0x20,%al
c00017d3:	e6 a0                	out    %al,$0xa0
c00017d5:	e6 20                	out    %al,$0x20
c00017d7:	83 c4 04             	add    $0x4,%esp
c00017da:	cf                   	iret   

c00017db <intr0x03entry>:
c00017db:	6a 00                	push   $0x0
c00017dd:	68 0c 30 00 c0       	push   $0xc000300c
c00017e2:	e8 a6 03 00 00       	call   c0001b8d <put_str>
c00017e7:	83 c4 04             	add    $0x4,%esp
c00017ea:	b0 20                	mov    $0x20,%al
c00017ec:	e6 a0                	out    %al,$0xa0
c00017ee:	e6 20                	out    %al,$0x20
c00017f0:	83 c4 04             	add    $0x4,%esp
c00017f3:	cf                   	iret   

c00017f4 <intr0x04entry>:
c00017f4:	6a 00                	push   $0x0
c00017f6:	68 0c 30 00 c0       	push   $0xc000300c
c00017fb:	e8 8d 03 00 00       	call   c0001b8d <put_str>
c0001800:	83 c4 04             	add    $0x4,%esp
c0001803:	b0 20                	mov    $0x20,%al
c0001805:	e6 a0                	out    %al,$0xa0
c0001807:	e6 20                	out    %al,$0x20
c0001809:	83 c4 04             	add    $0x4,%esp
c000180c:	cf                   	iret   

c000180d <intr0x05entry>:
c000180d:	6a 00                	push   $0x0
c000180f:	68 0c 30 00 c0       	push   $0xc000300c
c0001814:	e8 74 03 00 00       	call   c0001b8d <put_str>
c0001819:	83 c4 04             	add    $0x4,%esp
c000181c:	b0 20                	mov    $0x20,%al
c000181e:	e6 a0                	out    %al,$0xa0
c0001820:	e6 20                	out    %al,$0x20
c0001822:	83 c4 04             	add    $0x4,%esp
c0001825:	cf                   	iret   

c0001826 <intr0x06entry>:
c0001826:	6a 00                	push   $0x0
c0001828:	68 0c 30 00 c0       	push   $0xc000300c
c000182d:	e8 5b 03 00 00       	call   c0001b8d <put_str>
c0001832:	83 c4 04             	add    $0x4,%esp
c0001835:	b0 20                	mov    $0x20,%al
c0001837:	e6 a0                	out    %al,$0xa0
c0001839:	e6 20                	out    %al,$0x20
c000183b:	83 c4 04             	add    $0x4,%esp
c000183e:	cf                   	iret   

c000183f <intr0x07entry>:
c000183f:	6a 00                	push   $0x0
c0001841:	68 0c 30 00 c0       	push   $0xc000300c
c0001846:	e8 42 03 00 00       	call   c0001b8d <put_str>
c000184b:	83 c4 04             	add    $0x4,%esp
c000184e:	b0 20                	mov    $0x20,%al
c0001850:	e6 a0                	out    %al,$0xa0
c0001852:	e6 20                	out    %al,$0x20
c0001854:	83 c4 04             	add    $0x4,%esp
c0001857:	cf                   	iret   

c0001858 <intr0x08entry>:
c0001858:	90                   	nop
c0001859:	68 0c 30 00 c0       	push   $0xc000300c
c000185e:	e8 2a 03 00 00       	call   c0001b8d <put_str>
c0001863:	83 c4 04             	add    $0x4,%esp
c0001866:	b0 20                	mov    $0x20,%al
c0001868:	e6 a0                	out    %al,$0xa0
c000186a:	e6 20                	out    %al,$0x20
c000186c:	83 c4 04             	add    $0x4,%esp
c000186f:	cf                   	iret   

c0001870 <intr0x09entry>:
c0001870:	6a 00                	push   $0x0
c0001872:	68 0c 30 00 c0       	push   $0xc000300c
c0001877:	e8 11 03 00 00       	call   c0001b8d <put_str>
c000187c:	83 c4 04             	add    $0x4,%esp
c000187f:	b0 20                	mov    $0x20,%al
c0001881:	e6 a0                	out    %al,$0xa0
c0001883:	e6 20                	out    %al,$0x20
c0001885:	83 c4 04             	add    $0x4,%esp
c0001888:	cf                   	iret   

c0001889 <intr0x0aentry>:
c0001889:	90                   	nop
c000188a:	68 0c 30 00 c0       	push   $0xc000300c
c000188f:	e8 f9 02 00 00       	call   c0001b8d <put_str>
c0001894:	83 c4 04             	add    $0x4,%esp
c0001897:	b0 20                	mov    $0x20,%al
c0001899:	e6 a0                	out    %al,$0xa0
c000189b:	e6 20                	out    %al,$0x20
c000189d:	83 c4 04             	add    $0x4,%esp
c00018a0:	cf                   	iret   

c00018a1 <intr0x0bentry>:
c00018a1:	90                   	nop
c00018a2:	68 0c 30 00 c0       	push   $0xc000300c
c00018a7:	e8 e1 02 00 00       	call   c0001b8d <put_str>
c00018ac:	83 c4 04             	add    $0x4,%esp
c00018af:	b0 20                	mov    $0x20,%al
c00018b1:	e6 a0                	out    %al,$0xa0
c00018b3:	e6 20                	out    %al,$0x20
c00018b5:	83 c4 04             	add    $0x4,%esp
c00018b8:	cf                   	iret   

c00018b9 <intr0x0centry>:
c00018b9:	6a 00                	push   $0x0
c00018bb:	68 0c 30 00 c0       	push   $0xc000300c
c00018c0:	e8 c8 02 00 00       	call   c0001b8d <put_str>
c00018c5:	83 c4 04             	add    $0x4,%esp
c00018c8:	b0 20                	mov    $0x20,%al
c00018ca:	e6 a0                	out    %al,$0xa0
c00018cc:	e6 20                	out    %al,$0x20
c00018ce:	83 c4 04             	add    $0x4,%esp
c00018d1:	cf                   	iret   

c00018d2 <intr0x0dentry>:
c00018d2:	90                   	nop
c00018d3:	68 0c 30 00 c0       	push   $0xc000300c
c00018d8:	e8 b0 02 00 00       	call   c0001b8d <put_str>
c00018dd:	83 c4 04             	add    $0x4,%esp
c00018e0:	b0 20                	mov    $0x20,%al
c00018e2:	e6 a0                	out    %al,$0xa0
c00018e4:	e6 20                	out    %al,$0x20
c00018e6:	83 c4 04             	add    $0x4,%esp
c00018e9:	cf                   	iret   

c00018ea <intr0x0eentry>:
c00018ea:	90                   	nop
c00018eb:	68 0c 30 00 c0       	push   $0xc000300c
c00018f0:	e8 98 02 00 00       	call   c0001b8d <put_str>
c00018f5:	83 c4 04             	add    $0x4,%esp
c00018f8:	b0 20                	mov    $0x20,%al
c00018fa:	e6 a0                	out    %al,$0xa0
c00018fc:	e6 20                	out    %al,$0x20
c00018fe:	83 c4 04             	add    $0x4,%esp
c0001901:	cf                   	iret   

c0001902 <intr0x0fentry>:
c0001902:	6a 00                	push   $0x0
c0001904:	68 0c 30 00 c0       	push   $0xc000300c
c0001909:	e8 7f 02 00 00       	call   c0001b8d <put_str>
c000190e:	83 c4 04             	add    $0x4,%esp
c0001911:	b0 20                	mov    $0x20,%al
c0001913:	e6 a0                	out    %al,$0xa0
c0001915:	e6 20                	out    %al,$0x20
c0001917:	83 c4 04             	add    $0x4,%esp
c000191a:	cf                   	iret   

c000191b <intr0x10entry>:
c000191b:	6a 00                	push   $0x0
c000191d:	68 0c 30 00 c0       	push   $0xc000300c
c0001922:	e8 66 02 00 00       	call   c0001b8d <put_str>
c0001927:	83 c4 04             	add    $0x4,%esp
c000192a:	b0 20                	mov    $0x20,%al
c000192c:	e6 a0                	out    %al,$0xa0
c000192e:	e6 20                	out    %al,$0x20
c0001930:	83 c4 04             	add    $0x4,%esp
c0001933:	cf                   	iret   

c0001934 <intr0x11entry>:
c0001934:	90                   	nop
c0001935:	68 0c 30 00 c0       	push   $0xc000300c
c000193a:	e8 4e 02 00 00       	call   c0001b8d <put_str>
c000193f:	83 c4 04             	add    $0x4,%esp
c0001942:	b0 20                	mov    $0x20,%al
c0001944:	e6 a0                	out    %al,$0xa0
c0001946:	e6 20                	out    %al,$0x20
c0001948:	83 c4 04             	add    $0x4,%esp
c000194b:	cf                   	iret   

c000194c <intr0x12entry>:
c000194c:	6a 00                	push   $0x0
c000194e:	68 0c 30 00 c0       	push   $0xc000300c
c0001953:	e8 35 02 00 00       	call   c0001b8d <put_str>
c0001958:	83 c4 04             	add    $0x4,%esp
c000195b:	b0 20                	mov    $0x20,%al
c000195d:	e6 a0                	out    %al,$0xa0
c000195f:	e6 20                	out    %al,$0x20
c0001961:	83 c4 04             	add    $0x4,%esp
c0001964:	cf                   	iret   

c0001965 <intr0x13entry>:
c0001965:	6a 00                	push   $0x0
c0001967:	68 0c 30 00 c0       	push   $0xc000300c
c000196c:	e8 1c 02 00 00       	call   c0001b8d <put_str>
c0001971:	83 c4 04             	add    $0x4,%esp
c0001974:	b0 20                	mov    $0x20,%al
c0001976:	e6 a0                	out    %al,$0xa0
c0001978:	e6 20                	out    %al,$0x20
c000197a:	83 c4 04             	add    $0x4,%esp
c000197d:	cf                   	iret   

c000197e <intr0x14entry>:
c000197e:	6a 00                	push   $0x0
c0001980:	68 0c 30 00 c0       	push   $0xc000300c
c0001985:	e8 03 02 00 00       	call   c0001b8d <put_str>
c000198a:	83 c4 04             	add    $0x4,%esp
c000198d:	b0 20                	mov    $0x20,%al
c000198f:	e6 a0                	out    %al,$0xa0
c0001991:	e6 20                	out    %al,$0x20
c0001993:	83 c4 04             	add    $0x4,%esp
c0001996:	cf                   	iret   

c0001997 <intr0x15entry>:
c0001997:	6a 00                	push   $0x0
c0001999:	68 0c 30 00 c0       	push   $0xc000300c
c000199e:	e8 ea 01 00 00       	call   c0001b8d <put_str>
c00019a3:	83 c4 04             	add    $0x4,%esp
c00019a6:	b0 20                	mov    $0x20,%al
c00019a8:	e6 a0                	out    %al,$0xa0
c00019aa:	e6 20                	out    %al,$0x20
c00019ac:	83 c4 04             	add    $0x4,%esp
c00019af:	cf                   	iret   

c00019b0 <intr0x16entry>:
c00019b0:	6a 00                	push   $0x0
c00019b2:	68 0c 30 00 c0       	push   $0xc000300c
c00019b7:	e8 d1 01 00 00       	call   c0001b8d <put_str>
c00019bc:	83 c4 04             	add    $0x4,%esp
c00019bf:	b0 20                	mov    $0x20,%al
c00019c1:	e6 a0                	out    %al,$0xa0
c00019c3:	e6 20                	out    %al,$0x20
c00019c5:	83 c4 04             	add    $0x4,%esp
c00019c8:	cf                   	iret   

c00019c9 <intr0x17entry>:
c00019c9:	6a 00                	push   $0x0
c00019cb:	68 0c 30 00 c0       	push   $0xc000300c
c00019d0:	e8 b8 01 00 00       	call   c0001b8d <put_str>
c00019d5:	83 c4 04             	add    $0x4,%esp
c00019d8:	b0 20                	mov    $0x20,%al
c00019da:	e6 a0                	out    %al,$0xa0
c00019dc:	e6 20                	out    %al,$0x20
c00019de:	83 c4 04             	add    $0x4,%esp
c00019e1:	cf                   	iret   

c00019e2 <intr0x18entry>:
c00019e2:	90                   	nop
c00019e3:	68 0c 30 00 c0       	push   $0xc000300c
c00019e8:	e8 a0 01 00 00       	call   c0001b8d <put_str>
c00019ed:	83 c4 04             	add    $0x4,%esp
c00019f0:	b0 20                	mov    $0x20,%al
c00019f2:	e6 a0                	out    %al,$0xa0
c00019f4:	e6 20                	out    %al,$0x20
c00019f6:	83 c4 04             	add    $0x4,%esp
c00019f9:	cf                   	iret   

c00019fa <intr0x19entry>:
c00019fa:	6a 00                	push   $0x0
c00019fc:	68 0c 30 00 c0       	push   $0xc000300c
c0001a01:	e8 87 01 00 00       	call   c0001b8d <put_str>
c0001a06:	83 c4 04             	add    $0x4,%esp
c0001a09:	b0 20                	mov    $0x20,%al
c0001a0b:	e6 a0                	out    %al,$0xa0
c0001a0d:	e6 20                	out    %al,$0x20
c0001a0f:	83 c4 04             	add    $0x4,%esp
c0001a12:	cf                   	iret   

c0001a13 <intr0x1aentry>:
c0001a13:	90                   	nop
c0001a14:	68 0c 30 00 c0       	push   $0xc000300c
c0001a19:	e8 6f 01 00 00       	call   c0001b8d <put_str>
c0001a1e:	83 c4 04             	add    $0x4,%esp
c0001a21:	b0 20                	mov    $0x20,%al
c0001a23:	e6 a0                	out    %al,$0xa0
c0001a25:	e6 20                	out    %al,$0x20
c0001a27:	83 c4 04             	add    $0x4,%esp
c0001a2a:	cf                   	iret   

c0001a2b <intr0x1bentry>:
c0001a2b:	90                   	nop
c0001a2c:	68 0c 30 00 c0       	push   $0xc000300c
c0001a31:	e8 57 01 00 00       	call   c0001b8d <put_str>
c0001a36:	83 c4 04             	add    $0x4,%esp
c0001a39:	b0 20                	mov    $0x20,%al
c0001a3b:	e6 a0                	out    %al,$0xa0
c0001a3d:	e6 20                	out    %al,$0x20
c0001a3f:	83 c4 04             	add    $0x4,%esp
c0001a42:	cf                   	iret   

c0001a43 <intr0x1centry>:
c0001a43:	6a 00                	push   $0x0
c0001a45:	68 0c 30 00 c0       	push   $0xc000300c
c0001a4a:	e8 3e 01 00 00       	call   c0001b8d <put_str>
c0001a4f:	83 c4 04             	add    $0x4,%esp
c0001a52:	b0 20                	mov    $0x20,%al
c0001a54:	e6 a0                	out    %al,$0xa0
c0001a56:	e6 20                	out    %al,$0x20
c0001a58:	83 c4 04             	add    $0x4,%esp
c0001a5b:	cf                   	iret   

c0001a5c <intr0x1dentry>:
c0001a5c:	90                   	nop
c0001a5d:	68 0c 30 00 c0       	push   $0xc000300c
c0001a62:	e8 26 01 00 00       	call   c0001b8d <put_str>
c0001a67:	83 c4 04             	add    $0x4,%esp
c0001a6a:	b0 20                	mov    $0x20,%al
c0001a6c:	e6 a0                	out    %al,$0xa0
c0001a6e:	e6 20                	out    %al,$0x20
c0001a70:	83 c4 04             	add    $0x4,%esp
c0001a73:	cf                   	iret   

c0001a74 <intr0x1eentry>:
c0001a74:	90                   	nop
c0001a75:	68 0c 30 00 c0       	push   $0xc000300c
c0001a7a:	e8 0e 01 00 00       	call   c0001b8d <put_str>
c0001a7f:	83 c4 04             	add    $0x4,%esp
c0001a82:	b0 20                	mov    $0x20,%al
c0001a84:	e6 a0                	out    %al,$0xa0
c0001a86:	e6 20                	out    %al,$0x20
c0001a88:	83 c4 04             	add    $0x4,%esp
c0001a8b:	cf                   	iret   

c0001a8c <intr0x1fentry>:
c0001a8c:	6a 00                	push   $0x0
c0001a8e:	68 0c 30 00 c0       	push   $0xc000300c
c0001a93:	e8 f5 00 00 00       	call   c0001b8d <put_str>
c0001a98:	83 c4 04             	add    $0x4,%esp
c0001a9b:	b0 20                	mov    $0x20,%al
c0001a9d:	e6 a0                	out    %al,$0xa0
c0001a9f:	e6 20                	out    %al,$0x20
c0001aa1:	83 c4 04             	add    $0x4,%esp
c0001aa4:	cf                   	iret   

c0001aa5 <intr0x20entry>:
c0001aa5:	6a 00                	push   $0x0
c0001aa7:	68 0c 30 00 c0       	push   $0xc000300c
c0001aac:	e8 dc 00 00 00       	call   c0001b8d <put_str>
c0001ab1:	83 c4 04             	add    $0x4,%esp
c0001ab4:	b0 20                	mov    $0x20,%al
c0001ab6:	e6 a0                	out    %al,$0xa0
c0001ab8:	e6 20                	out    %al,$0x20
c0001aba:	83 c4 04             	add    $0x4,%esp
c0001abd:	cf                   	iret   
c0001abe:	66 90                	xchg   %ax,%ax

c0001ac0 <put_char>:
c0001ac0:	60                   	pusha  
c0001ac1:	66 b8 18 00          	mov    $0x18,%ax
c0001ac5:	8e e8                	mov    %eax,%gs
c0001ac7:	66 ba d4 03          	mov    $0x3d4,%dx
c0001acb:	b0 0e                	mov    $0xe,%al
c0001acd:	ee                   	out    %al,(%dx)
c0001ace:	66 ba d5 03          	mov    $0x3d5,%dx
c0001ad2:	ec                   	in     (%dx),%al
c0001ad3:	88 c4                	mov    %al,%ah
c0001ad5:	66 ba d4 03          	mov    $0x3d4,%dx
c0001ad9:	b0 0f                	mov    $0xf,%al
c0001adb:	ee                   	out    %al,(%dx)
c0001adc:	66 ba d5 03          	mov    $0x3d5,%dx
c0001ae0:	ec                   	in     (%dx),%al
c0001ae1:	66 89 c3             	mov    %ax,%bx
c0001ae4:	8b 4c 24 24          	mov    0x24(%esp),%ecx
c0001ae8:	80 f9 0d             	cmp    $0xd,%cl
c0001aeb:	74 3c                	je     c0001b29 <put_char.is_carriage_return>
c0001aed:	80 f9 0a             	cmp    $0xa,%cl
c0001af0:	74 37                	je     c0001b29 <put_char.is_carriage_return>
c0001af2:	80 f9 08             	cmp    $0x8,%cl
c0001af5:	74 02                	je     c0001af9 <put_char.is_backspace>
c0001af7:	eb 16                	jmp    c0001b0f <put_char.put_other>

c0001af9 <put_char.is_backspace>:
c0001af9:	66 4b                	dec    %bx
c0001afb:	66 d1 e3             	shl    %bx
c0001afe:	65 67 c6 07 20       	movb   $0x20,%gs:(%bx)
c0001b03:	66 43                	inc    %bx
c0001b05:	65 67 c6 07 07       	movb   $0x7,%gs:(%bx)
c0001b0a:	66 d1 eb             	shr    %bx
c0001b0d:	eb 60                	jmp    c0001b6f <put_char.set_cursor>

c0001b0f <put_char.put_other>:
c0001b0f:	66 d1 e3             	shl    %bx
c0001b12:	65 67 88 0f          	mov    %cl,%gs:(%bx)
c0001b16:	66 43                	inc    %bx
c0001b18:	65 67 c6 07 07       	movb   $0x7,%gs:(%bx)
c0001b1d:	66 d1 eb             	shr    %bx
c0001b20:	66 43                	inc    %bx
c0001b22:	66 81 fb d0 07       	cmp    $0x7d0,%bx
c0001b27:	7c 46                	jl     c0001b6f <put_char.set_cursor>

c0001b29 <put_char.is_carriage_return>:
c0001b29:	66 31 d2             	xor    %dx,%dx
c0001b2c:	66 89 d8             	mov    %bx,%ax
c0001b2f:	66 be 50 00          	mov    $0x50,%si
c0001b33:	66 f7 f6             	div    %si
c0001b36:	66 29 d3             	sub    %dx,%bx

c0001b39 <put_char.is_carriage_return_end>:
c0001b39:	66 83 c3 50          	add    $0x50,%bx
c0001b3d:	66 81 fb d0 07       	cmp    $0x7d0,%bx

c0001b42 <put_char.is_line_feed_end>:
c0001b42:	7c 2b                	jl     c0001b6f <put_char.set_cursor>

c0001b44 <put_char.roll_screen>:
c0001b44:	fc                   	cld    
c0001b45:	b9 c0 03 00 00       	mov    $0x3c0,%ecx
c0001b4a:	be a0 80 0b c0       	mov    $0xc00b80a0,%esi
c0001b4f:	bf 00 80 0b c0       	mov    $0xc00b8000,%edi
c0001b54:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0001b56:	bb 00 0f 00 00       	mov    $0xf00,%ebx
c0001b5b:	b9 50 00 00 00       	mov    $0x50,%ecx

c0001b60 <put_char.cls>:
c0001b60:	65 66 c7 03 20 07    	movw   $0x720,%gs:(%ebx)
c0001b66:	83 c3 02             	add    $0x2,%ebx
c0001b69:	e2 f5                	loop   c0001b60 <put_char.cls>
c0001b6b:	66 bb 80 07          	mov    $0x780,%bx

c0001b6f <put_char.set_cursor>:
c0001b6f:	66 ba d4 03          	mov    $0x3d4,%dx
c0001b73:	b0 0e                	mov    $0xe,%al
c0001b75:	ee                   	out    %al,(%dx)
c0001b76:	66 ba d5 03          	mov    $0x3d5,%dx
c0001b7a:	88 f8                	mov    %bh,%al
c0001b7c:	ee                   	out    %al,(%dx)
c0001b7d:	66 ba d4 03          	mov    $0x3d4,%dx
c0001b81:	b0 0f                	mov    $0xf,%al
c0001b83:	ee                   	out    %al,(%dx)
c0001b84:	66 ba d5 03          	mov    $0x3d5,%dx
c0001b88:	88 d8                	mov    %bl,%al
c0001b8a:	ee                   	out    %al,(%dx)

c0001b8b <put_char.put_char_done>:
c0001b8b:	61                   	popa   
c0001b8c:	c3                   	ret    

c0001b8d <put_str>:
c0001b8d:	53                   	push   %ebx
c0001b8e:	51                   	push   %ecx
c0001b8f:	31 c9                	xor    %ecx,%ecx
c0001b91:	8b 5c 24 0c          	mov    0xc(%esp),%ebx

c0001b95 <put_str.go_on>:
c0001b95:	8a 0b                	mov    (%ebx),%cl
c0001b97:	80 f9 00             	cmp    $0x0,%cl
c0001b9a:	74 0c                	je     c0001ba8 <put_str.str_over>
c0001b9c:	51                   	push   %ecx
c0001b9d:	e8 1e ff ff ff       	call   c0001ac0 <put_char>
c0001ba2:	83 c4 04             	add    $0x4,%esp
c0001ba5:	43                   	inc    %ebx
c0001ba6:	eb ed                	jmp    c0001b95 <put_str.go_on>

c0001ba8 <put_str.str_over>:
c0001ba8:	59                   	pop    %ecx
c0001ba9:	5b                   	pop    %ebx
c0001baa:	c3                   	ret    

c0001bab <my_set_cursor>:
c0001bab:	60                   	pusha  
c0001bac:	8b 5c 24 24          	mov    0x24(%esp),%ebx
c0001bb0:	66 81 fb d0 07       	cmp    $0x7d0,%bx
c0001bb5:	7d 1c                	jge    c0001bd3 <my_set_cursor.done>
c0001bb7:	66 ba d4 03          	mov    $0x3d4,%dx
c0001bbb:	b0 0e                	mov    $0xe,%al
c0001bbd:	ee                   	out    %al,(%dx)
c0001bbe:	66 ba d5 03          	mov    $0x3d5,%dx
c0001bc2:	88 f8                	mov    %bh,%al
c0001bc4:	ee                   	out    %al,(%dx)
c0001bc5:	66 ba d4 03          	mov    $0x3d4,%dx
c0001bc9:	b0 0f                	mov    $0xf,%al
c0001bcb:	ee                   	out    %al,(%dx)
c0001bcc:	66 ba d5 03          	mov    $0x3d5,%dx
c0001bd0:	88 d8                	mov    %bl,%al
c0001bd2:	ee                   	out    %al,(%dx)

c0001bd3 <my_set_cursor.done>:
c0001bd3:	61                   	popa   
c0001bd4:	c3                   	ret    

c0001bd5 <put_int>:
c0001bd5:	60                   	pusha  
c0001bd6:	89 e5                	mov    %esp,%ebp
c0001bd8:	8b 45 24             	mov    0x24(%ebp),%eax
c0001bdb:	89 c2                	mov    %eax,%edx
c0001bdd:	bf 07 00 00 00       	mov    $0x7,%edi
c0001be2:	b9 08 00 00 00       	mov    $0x8,%ecx
c0001be7:	bb a4 30 00 c0       	mov    $0xc00030a4,%ebx

c0001bec <put_int.16based_4bits>:
c0001bec:	83 e2 0f             	and    $0xf,%edx
c0001bef:	83 fa 09             	cmp    $0x9,%edx
c0001bf2:	7f 05                	jg     c0001bf9 <put_int.isA2F>
c0001bf4:	83 c2 30             	add    $0x30,%edx
c0001bf7:	eb 06                	jmp    c0001bff <put_int.store>

c0001bf9 <put_int.isA2F>:
c0001bf9:	83 ea 0a             	sub    $0xa,%edx
c0001bfc:	83 c2 41             	add    $0x41,%edx

c0001bff <put_int.store>:
c0001bff:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
c0001c02:	4f                   	dec    %edi
c0001c03:	c1 e8 04             	shr    $0x4,%eax
c0001c06:	89 c2                	mov    %eax,%edx
c0001c08:	e2 e2                	loop   c0001bec <put_int.16based_4bits>

c0001c0a <put_int.ready_to_print>:
c0001c0a:	47                   	inc    %edi

c0001c0b <put_int.skip_prefix_0>:
c0001c0b:	83 ff 08             	cmp    $0x8,%edi
c0001c0e:	74 0f                	je     c0001c1f <put_int.full0>

c0001c10 <put_int.go_on_skip>:
c0001c10:	8a 8f a4 30 00 c0    	mov    -0x3fffcf5c(%edi),%cl
c0001c16:	47                   	inc    %edi
c0001c17:	80 f9 30             	cmp    $0x30,%cl
c0001c1a:	74 ef                	je     c0001c0b <put_int.skip_prefix_0>
c0001c1c:	4f                   	dec    %edi
c0001c1d:	eb 02                	jmp    c0001c21 <put_int.put_each_num>

c0001c1f <put_int.full0>:
c0001c1f:	b1 30                	mov    $0x30,%cl

c0001c21 <put_int.put_each_num>:
c0001c21:	51                   	push   %ecx
c0001c22:	e8 99 fe ff ff       	call   c0001ac0 <put_char>
c0001c27:	83 c4 04             	add    $0x4,%esp
c0001c2a:	47                   	inc    %edi
c0001c2b:	8a 8f a4 30 00 c0    	mov    -0x3fffcf5c(%edi),%cl
c0001c31:	83 ff 08             	cmp    $0x8,%edi
c0001c34:	7c eb                	jl     c0001c21 <put_int.put_each_num>
c0001c36:	61                   	popa   
c0001c37:	c3                   	ret    
