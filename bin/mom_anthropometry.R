
### Set enviroment
library(dplyr)
library(ggplot2)
library(ggExtra)
library(tidyr)
library(forcats)
library(tibble)
library(ggpubr)
library(cowplot)
###Import metadata file 
madre <- read.delim("../meta/Antropometria_madre.tsv", header = TRUE, sep = "\t")


as_tibble(madre)


###Change names
colnames(madre) <- c("Numero", "Proyecto", "Edo", "Clave","Clinica","Fecha_nacimiento", 
                     "Edad_calculada","Edad_proporcionada", "Menarca", "Abortos", 
                     "SDG", "Fecha_parto", "Tipo_parto", "Estatura", 
                     "Peso_pre", "Imc_pre", "Edo_nutricio", 
                     "Ultimo_peso_gestacional", "Ganancia_peso", 
                     "Fecha_visita","Ultima_hr_lacto", "Hora_extraccion", 
                     "Peso_visita","Grasa_corporal","Agua_corporal", "Masa_muscular", 
                     "Masa_osea","IMC_visita", "Edo_nutricio_IMC","Edo_nutricio_adiposidad")	

###Select specific data
madre_select <- select(.data = madre,
                       -("Proyecto"|contains("Fecha")|"Edad_proporcionada"|
                           "Ultima_hr_lacto"|"Hora_extraccion"))%>%
                 mutate(Edo_nutricio_IMC=recode(Edo_nutricio_IMC,`SP`="SYO",`OB`="SYO"))%>%
                 drop_na()
madre_select

############################   Análisis SDG   ################################################
###Por IMC
SDG_IMC_figura <- ggplot(data=madre_select, mapping = aes(x=Edo_nutricio_IMC, y=SDG, fill=Edo_nutricio_IMC))+
  geom_boxplot(alpha=0.6,show.legend = FALSE)+
  geom_dotplot(binaxis='y', stackdir='center', dotsize=1, alpha=0.8,binwidth = 0.15)+
  labs(x=NULL, 
       y="Semanas de Gestación")+
  theme(plot.title=element_text(family="Calibri", size=16, face="bold"))+
  scale_fill_manual(values=c("#00407A","#93BF52"), 
                    name="Edo.Nutricio",
                    c("Normopeso(NP)","Sobrepeso y Obesidad (SYO)"))+
  theme_cowplot(12)

###Anova x IMC
SDG_Adiposidad_aov<- aov(SDG~Edo_nutricio_IMC, data=madre_select)
summary(SDG_Adiposidad)


#Por % de Adiposidad
SDG_Adiposidad_figura <- ggplot(data=madre_select, mapping = aes(x=Edo_nutricio_adiposidad, y=SDG, fill=Edo_nutricio_adiposidad))+
  geom_boxplot(alpha=0.6,show.legend = FALSE)+
  geom_dotplot(binaxis='y', stackdir='center', dotsize=1, alpha=0.8,binwidth = 0.15)+
  labs(x=NULL, 
       y="Semanas de Gestación")+
  theme(plot.title=element_text(family="Calibri", size=16, face="bold"))+
  scale_x_discrete(limits=c("SN", "OB"))+
  scale_fill_manual(values=c("#93BF52","#00407A"), 
                    name="Edo.Nutricio",
                    c("Obesidad (OB)","Sana(SN)"))+
  theme_cowplot(12)

###Anova x % Adiposidad
SDG_Adiposidad_aov<- aov(SDG~Edo_nutricio_adiposidad, data=madre_select)
summary(SDG_Adiposidad_aov)


Figura_SDG <- plot_grid(SDG_IMC, SDG_Adiposidad, 
                        labels = c("A", "B"),
                        label_size = 18,
                        rel_widths = c(1, 1))


############################   Análisis Tipo de Parto   ################################################
###Por IMC
ggplot(data=madre_select, mapping = aes(x=Edo_nutricio_IMC, y=IMC_visita, fill=Tipo_parto))+
  geom_violin(alpha=0.6)+
  labs(x=NULL, y="IMC (kg/m^2)")+
  theme(plot.title=element_text(family="Calibri", size=16, face="bold"))+
  scale_fill_manual(values=c("#00407A","#93BF52"), 
                    name="Tipo de Parto")+
  theme_cowplot(12)

###Anova x IMC
SDG_Adiposidad_aov<- aov(SDG~Edo_nutricio_IMC, data=madre_select)
summary(SDG_Adiposidad)


#Por % de Adiposidad
ggplot(data=madre_select, mapping = aes(x=Edo_nutricio_adiposidad, y=Grasa_corporal, fill=Tipo_parto))+
  geom_violin(alpha=0.6)+
  labs(x=NULL, y="IMC (kg/m^2)")+
  theme(plot.title=element_text(family="Calibri", size=16, face="bold"))+
  scale_x_discrete(limits=c("SN", "OB"))+
  scale_fill_manual(values=c("#00407A","#93BF52"), 
                    name="Tipo de Parto")+
  theme_cowplot(12)

###Anova x % Adiposidad
SDG_Adiposidad_aov<- aov(SDG~Edo_nutricio_adiposidad, data=madre_select)
summary(SDG_Adiposidad_aov)


Figura_SDG <- plot_grid(SDG_IMC, SDG_Adiposidad, 
                        labels = c("A", "B"),
                        label_size = 18,
                        rel_widths = c(1, 1))








madre_select%>%
  ggplot()+
  geom_point(mapping = aes(x=Peso_visita, y=Grasa_corporal, color=Tipo_parto))


  

###Agrupación por IMC
madre_select%>%
  group_by(Edo_nutricio_IMC)%>%
  arrange(desc(Edo))%>%
  summarise(mean=mean(IMC_visita), median(IMC_visita), 
            min(IMC_visita), max(IMC_visita),n=n())


###Agrupación por %Adiposidad
madre_select%>%
  group_by(Edo_nutricio_adiposidad)%>%
  arrange(desc(Edo))%>%
  summarise(Número=n(), 
            Promedio=mean(IMC_visita),
            Mediana=median(IMC_visita),
            Mínimo=min(IMC_visita), Máximo=max(IMC_visita))

ggplot(madre_select, mapping = aes(x=Edo_nutricio_adiposidad, y=SDG, fill=Edo_nutricio_adiposidad))+
  geom_boxplot(show.legend = FALSE)+
  geom_jitter(show.legend = FALSE)+
  theme_minimal()

ggplot(madre_select, mapping = aes(x=Edo_nutricio_IMC, y=SDG, fill=Edo_nutricio_IMC))+
  geom_boxplot(show.legend = FALSE)+
  geom_jitter(show.legend = FALSE)+
  theme_minimal()







###Anova por 


### Queremos saber cuantas madres tienen un IMC de peso normal pero por porcentaje de adiposidad son obesas
madre_select%>%
  group_by(Edo_nutricio_IMC, Edo_nutricio_adiposidad)%>%
  arrange(desc(Edo))%>%
  summarise(mean=mean(IMC_visita), median(IMC_visita), 
            min(IMC_visita), max(IMC_visita),n=n())


madre_select%>%
  ggplot()+
  geom_point(mapping = aes(x=Peso_visita, y=Grasa_corporal, color=Edo_nutricio_IMC))

madre_select%>%
  ggplot()+
  geom_point(mapping = aes(x=Peso_visita, y=Grasa_corporal, color=Edo_nutricio_adiposidad))

### El IMC no es un índice correcto para poder estratificar dos poblaciones, como si lo puede ser el porcentaje de adiposidad
head(madre_select) 
data_heatmap <- select(.data=madre_select, -("Clave" | "Edo"|"Tipo_parto"|"Edo_nutricio"|
                                              "Edo_nutricio_IMC"|"Edo_nutricio_adiposidad"))
data_heatmap
matrix_madre <- as.matrix(data_heatmap,colnames=TRUE)
is.matrix(data_heatmap)
heatmap(x = matrix_madre)
