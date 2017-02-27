from time import sleep
from SX127x.LoRa import *
from SX127x.LoRaArgumentParser import LoRaArgumentParser
from SX127x.board_config import BOARD

BOARD.setup()
#parser = LoRaArgumentParser("JJ CanSat Beacon")


class LoRaBeacon(LoRa):
    tx_counter = 0

    def setting(self):
        lora.set_freq(433.8)
        lora.set_preamble(int(8))
        lora.set_bw(7)
        # cr settings is #-4 when real setting is CR4_#
        lora.set_coding_rate(4)
        lora.set_ocp_trim(100)

    def __init__(self, verbose=False):
        super(LoRaBeacon, self).__init__(verbose)
        self.set_mode(MODE.SLEEP)
        self.set_dio_mapping([1, 0, 0, 0, 0, 0])

    def on_tx_done(self):
        self.set_mode(MODE.STDBY)
        self.setting()
        self.clear_irq_flags(TxDone=1)
        sys.stdout.flush()
        self.tx_counter += 1
        sys.stdout.write("\rtx #%d" % self.tx_counter)
        BOARD.led_off()
        self.write_payload([0x0f])
        sleep(time2sleep)
        BOARD.led_on()
        self.set_mode(MODE.TX)

    def on_cad_done(self):
        print("\non_CadDone")
        print(self.get_irq_flags())

    def on_rx_timeout(self):
        print("\non_RxTimeout")
        print(self.get_irq_flags())

    def on_valid_header(self):
        print("\non_ValidHeader")
        print(self.get_irq_flags())

    def on_payload_crc_error(self):
        print("\non_PayloadCrcError")
        print(self.get_irq_flags())

    def on_fhss_change_channel(self):
        print("\non_FhssChangeChannel")
        print(self.get_irq_flags())

    def start(self):
        #global args
        sys.stdout.write("\rstart")
        self.tx_counter = 0
        BOARD.led_on()
        while True:
            sleep(0.5)
            self.write_payload(
                [0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
                 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
                 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
                 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
                 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
                 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
                 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62,
                 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62, 0x62])
            self.set_mode(MODE.TX)


lora = LoRaBeacon(verbose=False)
"""
lora.set_freq(433.8)
lora.set_preamble(8)
lora.set_bw(7)
#cr settings is #-4 when real setting is CR4_#
lora.set_coding_rate(4)
lora.set_ocp_trim(100)
#args = parser.parse_args(lora)
"""
time2sleep = 0.3   # in seconds
lora.set_pa_config(pa_select=1)
assert (lora.get_agc_auto_on() == 1)
lora.start()
