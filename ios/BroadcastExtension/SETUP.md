# iOS Screen Sharing — wiring no Xcode (app aluno)

Os arquivos de código já estão prontos nesta pasta + `Runner/Info.plist` e `Runner/Runner.entitlements`
já foram editados. Falta o que **só dá pra fazer no Xcode + Apple Developer**. Faça nesta ordem.

Constantes usadas (têm que bater em todo lugar):
- **App Group:** `group.br.com.stepout.aluno`
- **Bundle id da extensão:** `br.com.stepout.aluno.broadcast`
- **Nome do target:** `BroadcastExtension`

---

## 1. Apple Developer (portal)

1. **Identifiers → App Groups → +** → cria `group.br.com.stepout.aluno`.
2. **Identifiers → App IDs**: no App ID do app (`br.com.stepout.aluno`), habilita **App Groups** e associa o grupo acima.
3. Cria um **App ID novo** pra extensão: `br.com.stepout.aluno.broadcast`, com **App Groups** habilitado e associado ao mesmo grupo.
4. Regera/baixa os **provisioning profiles** dos dois (ou deixa o Xcode "Automatically manage signing" cuidar).

## 2. Criar o target no Xcode

1. Abre `ios/Runner.xcworkspace` (workspace, não o project).
2. **File → New → Target… → Broadcast Upload Extension**.
   - Product Name: **BroadcastExtension**
   - Language: Swift
   - **NÃO** marque "Include UI Extension".
   - Embed in Application: **Runner**.
3. Quando perguntar "Activate scheme?", pode cancelar.
4. O Xcode cria uma pasta `BroadcastExtension/` com um `SampleHandler.swift` e `Info.plist` **dele**.
   **Apague os arquivos que o Xcode gerou** e, no lugar, **adicione (Add Files to "Runner"…)** os arquivos
   desta pasta, marcando **Target Membership = BroadcastExtension** (e só ela):
   - `SampleHandler.swift`
   - `SampleUploader.swift`
   - `SocketConnection.swift`
   - `DarwinNotificationCenter.swift`
   - `Atomic.swift`
   - `Info.plist`  → defina como o **Info.plist do target** (Build Settings → Packaging → Info.plist File)
   - `BroadcastExtension.entitlements` → Build Settings → **Code Signing Entitlements** = `BroadcastExtension/BroadcastExtension.entitlements`

## 3. Configurar o target BroadcastExtension

- **General → Bundle Identifier:** `br.com.stepout.aluno.broadcast`
- **Deployment Target:** iOS 15.1 (igual ao Runner)
- **Signing & Capabilities → + Capability → App Groups** → marca `group.br.com.stepout.aluno`
- **Signing:** mesmo time do Runner (automatic signing recomendado)

## 4. Confirmar o target Runner

- **Signing & Capabilities → App Groups** já deve aparecer (entitlements já editado) com `group.br.com.stepout.aluno` marcado. Se não aparecer, adicione a capability e marque o grupo.
- `Runner/Info.plist` já tem `RTCAppGroupIdentifier` e `RTCScreenSharingExtension` (não precisa mexer).

## 5. Podfile (provavelmente nada a fazer)

A extensão usa só **ReplayKit + CoreImage** (sem WebRTC/pods), então normalmente **não precisa**
de entrada no Podfile. Só rode `pod install` de novo (o Xcode pode ter mexido no project).
Se o build reclamar de algo de pod na extensão, aí sim adicionamos um `target 'BroadcastExtension'` no Podfile.

## 6. Build, versão e teste

- Bumpe a versão no `pubspec.yaml` (ex.: `1.0.0+10` → `1.0.0+11`).
- `flutter clean && flutter pub get`
- Buildar pelo Xcode (Archive) ou `flutter build ipa --release`.
- **Testar em iPhone REAL** (screen share não funciona em simulador):
  entrar na aula → botão "compartilhar tela" do Jitsi → escolher **"Stepout Broadcast"** no picker → confirmar.
- Subir no TestFlight.

---

## Como funciona (pra depurar)

- O botão de compartilhar tela é o **nativo do Jitsi** — aparece sozinho quando as 2 chaves do Info.plist + a extensão existem. Não há código Dart envolvido.
- Ao iniciar, o app (JitsiMeetSDK) cria um socket Unix `rtc_SSFD` no container do App Group.
- A extensão (`SampleHandler`) conecta nesse socket e envia os frames JPEG.
- Se o picker não listar "Stepout Broadcast": App Group não bate entre os targets, ou bundle id da extensão ≠ `RTCScreenSharingExtension`.
- Se lista mas não compartilha: confira que `appGroupIdentifier` em `SampleHandler.swift` == App Group == `RTCAppGroupIdentifier`.
