# 🌡️ Monitor de Temperatura com Raspberry Pi Pico e ThingSpeak

Este projeto realiza a leitura da **temperatura interna do Raspberry Pi Pico** e envia periodicamente os dados para o **ThingSpeak**, uma plataforma de IoT para visualização e análise de dados em tempo real.

---

## ⚙️ Estrutura do Projeto

```
├── main.py                  # Script principal: conecta ao Wi-Fi, lê o sensor e envia dados
├── config.py                # Configurações de Wi-Fi, ThingSpeak e sensor
├── sensor.py                # Classe para leitura do sensor de temperatura interno
├── temporizador.py          # Função auxiliar para temporização em milissegundos
└── thingspeak_client.py     # Cliente HTTP para envio de dados ao ThingSpeak
```

---

## 🚀 Funcionalidades

- Leitura da **temperatura interna** do Raspberry Pi Pico;
- Conexão automática à **rede Wi-Fi** configurada;
- Envio periódico dos dados para o **ThingSpeak**;
- Log detalhado no console com temperatura e status do envio.

---

## 🔧 Instalação e Configuração

### 1. Requisitos

- Raspberry Pi Pico W  
- Firmware **MicroPython** instalado  
- Biblioteca `urequests` disponível (inclusa em builds recentes)

### 2. Configuração da Rede e da API

Edite o arquivo `config.py`:

```python
# CONFIGURAÇÕES DE REDE
WIFI_SSID = "NomeDaSuaRede"
WIFI_PASS = "SenhaDaSuaRede"

# CONFIGURAÇÕES DO THINGSPEAK
THINGSPEAK_API_KEY = "SUA_API_KEY_AQUI"
INTERVALO_ENVIO_MS = 15000  # Tempo entre envios (em ms)
```

> ⚠️ Não compartilhe seu arquivo `config.py` publicamente, pois contém credenciais sensíveis.

---

## ▶️ Execução

1. Envie todos os arquivos para o Raspberry Pi Pico (via Thonny ou rshell);
2. Execute o script principal:

```python
>>> import main
```

3. O dispositivo irá:
   - Conectar-se ao Wi-Fi;
   - Ler a temperatura interna;
   - Enviar os dados para o seu canal no ThingSpeak a cada intervalo configurado.

---

## ☁️ Integração com ThingSpeak

- Crie uma conta gratuita em [ThingSpeak](https://thingspeak.com/)
- Crie um novo **Channel**
- Copie a **Write API Key** e insira em `config.py`
- Adicione um gráfico de linha para o campo `field1` para visualizar as leituras em tempo real.

---

## 📈 Exemplo de Saída no Console

```
Conectando ao Wi-Fi...
Wi-Fi conectado: ('192.168.0.10', '255.255.255.0', '192.168.0.1', '8.8.8.8')
Temperatura medida: 31.25 °C
Resposta ThingSpeak: 12345
Dados enviados para ThingSpeak com sucesso.
```

---

## 💡 Possíveis Melhorias

- Envio de múltiplos campos (umidade, luminosidade etc.);
- Armazenamento local em caso de falha de rede;
- Integração com MQTT para comunicação em tempo real;
- Uso de sensores externos (como DHT11/DHT22).

---
