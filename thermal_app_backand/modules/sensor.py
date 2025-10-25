from machine import ADC

class SensorTemperatura:
    def __init__(self, canal_adc=4):
        self.sensor = ADC(canal_adc)
        self.conversao = 3.3 / 65535

    def ler(self):
        leitura = self.sensor.read_u16() * self.conversao
        temperatura = 27 - (leitura - 0.706) / 0.001721
        return temperatura
