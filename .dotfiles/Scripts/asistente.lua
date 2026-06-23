local cjson = require("cjson")

local api_key = os.getenv("GROQ_API_KEY")
if not api_key then
    print("[!] Error: No se encontró la variable GROQ_API_KEY.")
    os.exit(1)
end

-- Endpoint oficial de Groq (sigue el estándar de OpenAI)
local url = "https://api.groq.com/openai/v1/chat/completions"

---conecta
local function consultar_groq(payload_json)
    local safe_payload = payload_json:gsub("'", "'\\''")

    local cmd = string.format("curl -s -w '\\n||%%{http_code}' -X POST '%s' " .. "-H 'Authorization: Bearer %s' " ..
                                  "-H 'Content-Type: application/json' " .. "-d '%s'", url, api_key, safe_payload)

    local handle = io.popen(cmd)
    local result = handle:read("*a")
    handle:close()

    local body, code_str = result:match("^(.-)\n||(%d+)$")
    return tonumber(code_str) or 0, body
end

--envia a grok
local function enviar(payload_table)
    local payload_json = cjson.encode(payload_table)

    local code, body = consultar_groq(payload_json)

    if code == 200 then
        local success, data = pcall(cjson.decode, body)
        if success and data.choices and data.choices[1] and data.choices[1].message then
            local texto_ia = data.choices[1].message.content
            print("\n[Groq]: " .. texto_ia)
        else
            print("[!] Error al parsear la respuesta de Groq.")
        end
    else
        print("[!] Error en la API de Groq (Código " .. tostring(code) .. "): " .. tostring(body))
    end
end




-- Payload usando Llama 3.3 de 70 parámetros (una bestia de modelo)
while true do
    print(" ")
    print(" ")
    local mensaje = io.read()


    --construye el mensaje
    local payload_table = {
        model = "llama-3.3-70b-versatile",
        messages = {{
            role = "user",
            content = mensaje
        }}
    }

    if mensaje == "clear" then
        --limpia la pantalla
        os.execute("clear")

    elseif mensaje == "exit" then
        --sale
        print("saliendo...")
        break
    else
        --manda a grok el mensaje
        enviar(payload_table)
    end
    
end
