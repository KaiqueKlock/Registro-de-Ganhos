# 📱 App de Ganhos Diários

<p align="center">
  <img src="https://github.com/user-attachments/assets/cb67d59e-a650-4d76-880c-87c917e8adf2" width="250"/>
  <img src="https://github.com/user-attachments/assets/395aa4bc-66da-486c-8c2a-a8694588c65a" width="250"/>
  <img src="https://github.com/user-attachments/assets/76eab94a-c929-4eb8-afd9-936031a8faba" width="250"/>
</p>

Aplicativo mobile desenvolvido em **Flutter** para registrar e acompanhar ganhos financeiros diários, permitindo visualizar resultados mensais de forma simples e organizada.

O projeto nasceu da observação de uma situação real:  
meu pai registra seus ganhos diários manualmente em um caderno.

A ideia do aplicativo surgiu como uma forma de **digitalizar esse processo**, tornando o registro mais rápido e permitindo uma visualização melhor dos resultados ao longo do mês.

Além de resolver um problema prático, o projeto também foi desenvolvido como parte do meu processo de **aprendizado em Flutter e desenvolvimento mobile**.

---

# 🎯 Objetivo do Projeto

Este projeto foi criado com o objetivo de praticar conceitos fundamentais do desenvolvimento mobile utilizando **Flutter e Dart**, aplicando na prática:

- Estruturação de projetos Flutter  
- Manipulação e persistência de dados  
- Implementação de CRUD  
- Navegação entre telas  
- Organização de código  
- Experiência do usuário (UX)  
- Estrutura de dados reutilizável  

O foco do aplicativo é permitir **registro rápido de ganhos, sem complexidade desnecessária.**

---

# ⚙️ Tecnologias Utilizadas

- Flutter  
- Dart  
- Hive (persistência de dados local)  
- Intl (formatação de datas e valores monetários)  
- Git  
- GitHub  

---

# 📱 Funcionalidades

✔ Registro de ganhos diários  
✔ Edição de registros existentes  
✔ Exclusão de registros  
✔ Persistência local dos dados  
✔ Visualização de ganhos acumulados no mês  
✔ Meta mensal configurável  
✔ Barra de progresso da meta  
✔ Comparação com o mesmo período do mês anterior  
✔ Seleção de tema personalizado pelo usuário  

O objetivo do aplicativo é manter a experiência **simples e rápida**, permitindo registrar ganhos em poucos segundos.

---

# 🧠 Decisões Técnicas

Durante o desenvolvimento do projeto algumas decisões foram tomadas para melhorar a **estrutura do aplicativo e a experiência do usuário**.

---

## Uso de `showDialog` para criação e edição de registros

Durante o desenvolvimento foram testadas diferentes abordagens para abrir o formulário de registro de ganhos:

- Navegação para uma nova tela
- Uso de BottomSheet
- Uso de Dialog

Após testes, foi escolhido o uso de **showDialog**, pois ele permite que o usuário registre ou edite ganhos **sem sair da tela principal**, tornando a interação mais rápida e fluida.

Essa abordagem reduz a complexidade da navegação e melhora a experiência do usuário em operações rápidas, como adicionar ou corrigir um valor.

---

## Persistência de dados com Hive

Inicialmente os dados eram armazenados apenas em memória utilizando `setState`.

Com a evolução do projeto foi implementada **persistência local utilizando Hive**, permitindo que os registros continuem disponíveis mesmo após fechar o aplicativo.

A escolha do Hive foi feita por ser:

- leve  
- rápido  
- simples de implementar  
- adequado para aplicações mobile offline  

---

## Atualização automática da interface com ValueListenableBuilder

Para evitar chamadas manuais de atualização da interface, foi adotado o uso de **ValueListenableBuilder**.

Essa abordagem permite que a interface seja atualizada automaticamente sempre que houver alterações no banco local, reduzindo a necessidade de controle manual de estado.

---

## Formatação de valores monetários e datas

Para melhorar a experiência do usuário foram aplicadas algumas melhorias de apresentação:

- formatação monetária utilizando **intl**
- formatação de datas no formato reduzido (ex: `27/fev`)
- uso de **InputFormatter** para facilitar digitação de valores financeiros

Essas decisões ajudam a manter a interface mais próxima de **aplicativos financeiros reais**.

---

## Interface focada em rapidez de uso

Como o objetivo principal do aplicativo é **registrar ganhos rapidamente**, a interface foi pensada para:

- minimizar quantidade de cliques
- manter telas simples
- permitir edição rápida dos registros
- destacar as informações mais importantes (meta e progresso mensal)

---

## Evolução da visualização de métricas

Durante o desenvolvimento a interface passou por algumas revisões de UX.

Inicialmente eram exibidos:

- total do mês
- valorização
- meta

Com o tempo percebeu-se que algumas informações eram redundantes.

A interface foi então simplificada para destacar:

- progresso em relação à meta mensal
- comparação com o mesmo período do mês anterior
- lista de registros do mês

Essa abordagem melhora a **clareza das informações exibidas**.

---

# 📚 Conceitos Aplicados

Este projeto demonstra na prática:

- CRUD completo (Create, Read, Update, Delete)
- Persistência local com Hive
- Componentização de widgets
- Navegação no Flutter
- Gerenciamento de estado simples
- Formatação de dados
- Estrutura básica de aplicações mobile
- Organização de código
- Tomada de decisões de UX

---

# 🚀 Possíveis Evoluções

O projeto foi desenvolvido com uma estrutura que permite futuras evoluções, como:

- gráficos de ganhos
- relatórios mensais
- exportação de dados
- sincronização com backend
- metas semanais
- dashboard de desempenho financeiro

---

# 👨‍💻 Autor

**Kaique Klock**

Projeto criado como parte do processo de aprendizado em **desenvolvimento mobile com Flutter**.
