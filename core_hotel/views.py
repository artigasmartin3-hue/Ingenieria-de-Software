from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def login_view(request):
    # Recibe email y password, verifica el hash con Bcrypt y guarda id y rol en sesión.
    return render(request, 'login.html', {'error': None})

def logout_view(request):

    # Destruye la sesión activa y redirige al login.
    return render(request, 'login.html', {'error': None})

def gestion_habitaciones(request):
    # Lista todas las habitaciones.
    # Si recibe fechas por GET, filtra y muestra solo las que no tienen reservas cruzadas.
    # Si recibe datos por POST, registra una nueva habitación.
    return render(request, 'habitaciones.html', {'habitaciones': []})

def cambiar_estado_habitacion(request, id_hab, nuevo_estado):
    # Cambia rápidamente el estado entre DISPONIBLE, OCUPADA o EN_MANTENCION.
    return render(request, 'habitaciones.html', {'habitaciones': []})

def gestion_huespedes(request):
    # Si recibe RUT o Nombre por GET, ejecuta tus búsquedas filtradas (previniendo SQL Injection).
    # Si recibe datos por POST, registra un nuevo cliente y/o huésped validando que el RUT no se repita.
    return render(request, 'huespedes.html', {'huespedes': []})

def gestion_reservas(request):
    # Muestra el listado de reservas actuales.
    # Si recibe datos por POST, valida fechas/capacidad y crea el registro en 'reserva' y 'detalle_reserva'.
    return render(request, 'reservas.html', {'reservas': []})

def procesar_checkin(request, id_reserva):
    # Pasa la reserva a CONFIRMADA, asocia los huéspedes y cambia la habitación a OCUPADA.
    return render(request, 'reservas.html', {'reservas': []})

def procesar_checkout(request, id_reserva):
    # Finaliza la estadía y libera la habitación dejándola DISPONIBLE.
    return render(request, 'reservas.html', {'reservas': []})

def cancelar_reserva(request, id_reserva):
    # Cambia el estado de la reserva a CANCELADA y libera la habitación.
    return render(request, 'reservas.html', {'reservas': []})