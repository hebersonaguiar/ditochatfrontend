# Imagem base, possui as instalações npm necessárias para a aplicação
FROM hebersonaguiar/nodebase:1.0

# Mantenedor da Imagem
LABEL maintainer="Heberson Aguiar <hebersonaguiar@gmail.com>"

# Diretório padrão da imagem
WORKDIR /app

# Adiciona o node_modules ao PATH
ENV PATH /app/node_modules/.bin:$PATH

# Copia os arquivos de pacotes node
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
   
#Copia o entrypoint, necessário para realizar a alteração das variáveis   
COPY docker-entrypoint.sh /entrypoint.sh

# Adiciona permissão de execução ao entrypoint
RUN chmod +x /entrypoint.sh  

# Copia os código fonte
COPY public /app/public
COPY src /app/src

# Executa o entrypoit
ENTRYPOINT ["/entrypoint.sh"]

#Expondo a porta 3000    
EXPOSE 3000

# Inicia a aplicação com npm
CMD ["npm", "start"]
