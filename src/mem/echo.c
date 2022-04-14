/*
 * Copyright (C) 2009 - 2018 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#include <stdio.h>
#include <string.h>

#include "letters.h"

#include "xil_io.h"
#include "loadManage.h"
#include "xparameters.h"

#include "lwip/err.h"
#include "lwip/tcp.h"
#if defined (__arm__) || defined (__aarch64__)
#include "xil_printf.h"
#endif

///////////////////// TEAM 5 - START ///////////////
//#include "xparameters.h"

//signed short* membase = (signed short*) XPAR_MIG_7SERIES_0_BASEADDR;

///////////////////// TEAM 5 - END ///////////////

int transfer_data() {
	return 0;
}

void print_app_header()
{
#if (LWIP_IPV6==0)
	xil_printf("\n\r\n\r-----lwIP TCP echo server ------\n\r");
#else
	xil_printf("\n\r\n\r-----lwIPv6 TCP echo server ------\n\r");
#endif
	xil_printf("TCP packets sent to port 6001 will be echoed back\n\r");
}

err_t recv_callback(void *arg, struct tcp_pcb *tpcb,
                               struct pbuf *p, err_t err)
{
	/* do not read the packet if we are not in ESTABLISHED state */
	if (!p) {
		tcp_close(tpcb);
		tcp_recv(tpcb, NULL);
		return ERR_OK;
	}

	/* indicate that the packet has been received */
	tcp_recved(tpcb, p->len);

	/* echo back the payload */
	/* in this case, we assume that the payload is < TCP_SND_BUF */
	if (tcp_sndbuf(tpcb) > p->len) {

		/*struct pbuf *temp_p = p;	// temporary pointer

		unsigned int i;
		unsigned int buf_len = p->tot_len;
		//xil_printf("buf_len = %d\n", buf_len);

		//xil_printf("Received: ");
		for (i = 0; i < buf_len; i+=2) {
			signed short val = *((signed short *)((temp_p->payload)+i));
			*(membase+(i/2)) = val;
			xil_printf("Reading from: %p ---> Storing at: %p ---> Value: %x\n", (signed short *)((temp_p->payload)+i), (membase+(i/2)), val);
		}*/

		u16_t p_len = p->tot_len;
		int i;
		signed char value;
		value = *((signed char *)(p->payload));
		signed char out_val = value;
		xil_printf("value = %c\n", value);
		if (value == 49){
			xil_printf("Received a compute request\n");
			signed char station_no = (signed char)(LOADMANAGE_mReadReg(XPAR_LOADMANAGE_0_S00_AXI_BASEADDR, LOADMANAGE_S00_AXI_SLV_REG7_OFFSET));
			xil_printf("Assigning request to station no: %d\n", station_no);
			out_val = station_no;
			LOADMANAGE_mWriteReg(XPAR_LOADMANAGE_0_S00_AXI_BASEADDR, LOADMANAGE_S00_AXI_SLV_REG6_OFFSET, 1);
		} else if (value == 53){
			u16_t num_words = *((u16_t*)((p->payload)+1));
			for (i = 2; i < num_words + 2; i++){
				u16_t word_idx = *((u16_t*)((p->payload)+i));
//				drawSentence(VID_ADDR, TL_X, TL_Y + 100, "", white, black);
			}
		} else {
			xil_printf("Not a compute request, simply echoing back received data\n");
		}


		//err = tcp_write(tpcb, p->payload, p->len, 1);	// send back packet
		err = tcp_write(tpcb, &out_val, p->len, 1);	// send back packet
	} else
		xil_printf("no space in tcp_sndbuf\n\r");

	/* free the received pbuf */
	pbuf_free(p);

	return ERR_OK;
}

err_t accept_callback(void *arg, struct tcp_pcb *newpcb, err_t err)
{
	static int connection = 1;

	/* set the receive callback for this connection */
	tcp_recv(newpcb, recv_callback);

	/* just use an integer number indicating the connection id as the
	   callback argument */
	tcp_arg(newpcb, (void*)(UINTPTR)connection);

	/* increment for subsequent accepted connections */
	connection++;

	return ERR_OK;
}


int start_application()
{
	struct tcp_pcb *pcb;
	err_t err;
	unsigned port = 7;

	/* create new TCP PCB structure */
	pcb = tcp_new_ip_type(IPADDR_TYPE_ANY);
	if (!pcb) {
		xil_printf("Error creating PCB. Out of Memory\n\r");
		return -1;
	}

	/* bind to specified @port */
	err = tcp_bind(pcb, IP_ANY_TYPE, port);
	if (err != ERR_OK) {
		xil_printf("Unable to bind to port %d: err = %d\n\r", port, err);
		return -2;
	}

	/* we do not need any arguments to callback functions */
	tcp_arg(pcb, NULL);

	/* listen for connections */
	pcb = tcp_listen(pcb);
	if (!pcb) {
		xil_printf("Out of memory while tcp_listen\n\r");
		return -3;
	}

	/* specify callback to use for incoming connections */
	tcp_accept(pcb, accept_callback);

	xil_printf("TCP echo server started @ port %d\n\r", port);

	return 0;
}
