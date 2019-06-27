class Planta {
	
	method horasDeSolQueTolera(){
		return 2
	}
	method esFuerte(){
		return self.horasDeSolQueTolera()>10
	}
}
class Menta inherits Planta{
	const property anioDeObtencion=6
    const property altura=1
    
    method daNuevasSemillas(){
		return altura>0.4 or self.esFuerte()
	}
	method espacioQueOcupa(){
		return altura*3
	}
	override method horasDeSolQueTolera(){
		return 6
	}
	method parcelaEsIdeal(parcela){
		return parcela.superficie()>6
	}
}
class Soja inherits Planta{
	const property anioDeObtencion
    const property altura
    
    override method horasDeSolQueTolera(){
    	if(altura<0.5){
    		return 6
    	}
    	else{if(altura>1){
    		return 9
    	}
    	else{return 7}
    	}
    }
    method daNuevasSemillas(){
    	return self.esFuerte() or (self.semillaObtenidaRecientemente() and altura>1)
    }
    method semillaObtenidaRecientemente(){
    	return anioDeObtencion>2007
    }
    method espacioQueOcupa(){
    	return altura/2
    }
    method parcelaEsIdeal(parcela){
    	return self.horasDeSolQueTolera()==parcela.horasDeSol()
    }
}
class Quinoa inherits Planta{
	const property anioDeObtencion
    const property altura
    var   property horasDeSolQueTolera
    override method horasDeSolQueTolera(){
    	return horasDeSolQueTolera
    }
    method espacioQueOcupa(){
    	return 0.5
    }
    method daNuevasSemillas(){
    	return self.esFuerte() or self.semillaEsVieja()
    }
    method semillaEsVieja(){
    	return anioDeObtencion<2005
    }
    method parcelaEsIdeal(parcela){
    	return not parcela.plantas().any({planta=>planta.altura()>1.5})
    }
}
class SojaTransgenica inherits Soja{
	override method daNuevasSemillas(){
		return false
	}
    override method parcelaEsIdeal(parcela){
    	return parcela.maximoDePlantas()==1
    }
}
class HierbaBuena inherits Menta{
	override method espacioQueOcupa(){
		return 2*(altura*3)
	}
}
class Parcela{
	const ancho
	const largo
	const property horasDeSol
	const property plantas
	const property tipoDeParcela
	
	method superficie(){
		return ancho * largo
	}
	method maximoDePlantas(){
		if(ancho>largo){
			return self.superficie() /5
		}
		else{return self.superficie()/3+largo}
	}
	method tieneComplicaciones(){
		return plantas.any({planta=>planta.horasDeSolQueTolera()<horasDeSol})
	}
	method noHayMasEpacio(){
		return self.maximoDePlantas()<=plantas.size()
	}
	method plantarUnaPlanta(planta){
		if(self.noHayMasEpacio() or self.plantaRecibeDosHorasOMas(planta)){
			 throw new Exception("ya esta con el maximo de plantas o recibe demasiado sol")
		}
		else{plantas.add(planta)}
	}
	method plantaRecibeDosHorasOMas(planta){
		return planta.horasDeSolQueTolera()+2<=horasDeSol
	}
	method seAsociaBienAca(planta){
		if(tipoDeParcela=="ecologica"){
			return not self.tieneComplicaciones() and planta.parcelaEsIdeal(self)
		}
		else{return plantas.size()<=2 and planta.esFuerte()}
	}
	method cantidadDePlantasBienAsociadas(){
		return plantas.filter({planta=>self.seAsociaBienAca(planta)}).size()
	}
}
object inta{
	var property parcelas=[]
	
	method promedioDePlantasPorParcela(){
		return self.cantidadDePlantasEnLasParcelas()/parcelas.size()
	}
	method cantidadDePlantasEnLasParcelas(){
		return parcelas.sum({parcela=>parcela.plantas().size()})
	}
	method parcelaMasAutosustentable(){
		return self.parcelasConMasDeCuatroPlantas().max({parcela=>parcela.cantidadDePlantasBienAsociadas()})
	}
	method parcelasConMasDeCuatroPlantas(){
		return parcelas.filter({parcela=>parcela.plantas().size()>=4})
	}
	method agregarParcela(parcela){
		parcelas.add(parcela)
	}
}







































