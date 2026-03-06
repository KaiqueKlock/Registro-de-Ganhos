# 📱 App de Ganhos Diários

Aplicativo mobile desenvolvido em **Flutter** para registrar e acompanhar ganhos financeiros diários, permitindo visualizar resultados mensais de forma simples e organizada.

O projeto nasceu da observação de uma situação real:  
meu pai registra seus ganhos diários manualmente em um caderno. A ideia do aplicativo surgiu como uma forma de **digitalizar esse processo**, tornando o registro mais rápido e permitindo uma visualização melhor dos resultados ao longo do mês.

Além de resolver um problema prático, o projeto também foi desenvolvido como parte do meu **processo de aprendizado em Flutter e desenvolvimento mobile**.

---

# 🎯 Objetivo do Projeto

Este projeto foi criado com o objetivo de praticar conceitos fundamentais do desenvolvimento mobile utilizando **Flutter e Dart**, aplicando na prática:

- Estruturação de projetos Flutter
- Manipulação e persistência de dados
- Implementação de CRUD
- Navegação entre telas
- Organização de código
- Experiência do usuário (UX)

---

# ⚙️ Tecnologias Utilizadas

- Flutter
- Dart
- Persistência de dados local
- Git
- GitHub

---

# 📱 Funcionalidades

✔ Registro de ganhos diários  
✔ Edição de registros existentes  
✔ Exclusão de registros  
✔ Visualização de ganhos acumulados no mês  
✔ Organização simples e rápida dos dados  

O objetivo do aplicativo é manter a **experiência simples e rápida**, permitindo registrar ganhos em poucos segundos.

---

# 🧠 Decisões Técnicas

Durante o desenvolvimento do projeto algumas decisões foram tomadas para melhorar a estrutura do aplicativo e a experiência do usuário.

### Uso de `showDialog` para criação e edição de registros

Durante o desenvolvimento foram testadas diferentes abordagens para abrir o formulário de registro de ganhos:

- Navegação para uma nova tela
- Uso de `BottomSheet`
- Uso de `Dialog`

Após testes, foi escolhido o uso de **`showDialog`**, pois ele permite que o usuário registre ou edite ganhos **sem sair da tela principal**, tornando a interação mais rápida e fluida.

Essa abordagem reduz a complexidade da navegação e melhora a **experiência do usuário em operações rápidas**, como adicionar ou corrigir um valor.

---

### Estrutura de dados simples para facilitar evolução do projeto

Os registros são armazenados em uma estrutura simples baseada em objetos contendo:

- valor do ganho
- data
- observações

Essa abordagem facilita futuras evoluções do projeto, como:

- relatórios mensais
- gráficos
- exportação de dados
- sincronização com backend

---

### Interface focada em rapidez de uso

Como o objetivo principal do aplicativo é registrar ganhos rapidamente, a interface foi pensada para:

- minimizar quantidade de cliques
- manter telas simples
- permitir edição rápida dos registros

---

# 📚 Conceitos Aplicados

Este projeto demonstra na prática:

- CRUD completo (Create, Read, Update, Delete)
- Manipulação de listas e dados
- Componentização de widgets
- Navegação no Flutter
- Estrutura básica de aplicações mobile
- Organização de código


# 👨‍💻 Autor
Desenvolvido por Kaique Klock

