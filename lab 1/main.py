from datetime import datetime, date

from models import Supplier
from repository import SupplierRepository
from tests import test_suppliers

rep = SupplierRepository()

for s in test_suppliers:
    rep.create(s)

def get_input(prompt, ctype: type = str, default=None):
    val = input(prompt).strip()
    if not val:
        return default
    try:
        if ctype == date:
            return datetime.strptime(val, "%Y-%m-%d").date()
        return ctype(val)
    except ValueError:
        print("Некоректний формат")
        return default


while True:
    print("Виберіть дію: ")
    print("1. Вивести всю інформацію")
    print("2. Додати постачальника")
    print("3. Оновити постачальника")
    print("4. Видалити постачальника")
    print("5. Завершити роботу")

    choice = get_input("> ", ctype=int)

    if choice == 1:
        print("--- Виведення інформації ---")
        while True:
            p = get_input("Введіть номер сторінки, 0 для виходу: ", ctype=int)
            if p == 0 or p is None:  break
            items = rep.get_all(page=p)
            for it in items:
                print(f"{'='*30}\n"
                      f"ID: {it.id} \n"
                      f"Назва: {it.name} \n"
                      f"Товар: {it.product} \n"
                      f"Ціна: {it.price} грн\n"
                      f"Дата поставки: {it.nextDelivery} \n"
                      f"Телефон: {it.phone} \n"
                      f"Емейл: {it.email} \n"
                      f"Фото: {it.photo_path}"
                      f"\n{'='*30}\n")
            print(f"Сторінка: {p}")

    elif choice == 2:
        print("--- Додавання нового постачальника ---")

        name = get_input("Назва: ")
        product = get_input("Товар: ")

        nextDelivery = get_input("Дата поставки (РРРР-ММ-ДД): ", ctype=date)
        price = get_input("Ціна: ", ctype=float, default=0.0)

        phone = get_input("Телефон (опціонально): ")
        email = get_input("Емейл (опціонально): ")
        photo_path = get_input("Шлях до фото (опціонально): ")

        if name and product and nextDelivery and price:
            rep.create(Supplier(
                name=name,
                product=product,
                nextDelivery=nextDelivery,
                price=price,
                phone=phone,
                email=email,
                photo_path=photo_path
            ))
            print(f"Постачильника додано")
        else:
            print("Помилка: Назва, Товар, Дата, Ціна є обов'язковими!")


    elif choice == 3:
        print("--- Оновлення постачальника ---")

        sup_id = get_input("Введіть ID для оновлення: ", ctype=int)

        if sup_id is not None:
            updates = {}

            print("Enter щоб пропустити оновлення")
            name = get_input("Назва : ")
            if name: updates["name"] = name

            product = get_input("Товар : ")
            if name: updates["product"] = product

            d_str = get_input("Дата (РРРР-ММ-ДД): ", ctype=date)
            if d_str: updates["nextDelivery"] = d_str

            price = get_input("Ціна: ", ctype=float)
            if price is not None: updates["price"] = price

            phone = get_input("Телефон : ")
            if phone: updates["phone"] = phone

            email = get_input("Емейл : ")
            if email: updates["email"] = email

            photo_path = get_input("Фото : ")
            if photo_path: updates["photo_path"] = photo_path

            if updates:
                if rep.update(sup_id, **updates):
                    print("Дані оновлено!")
                else:
                    print("Оновлень не знайдено.")

    elif choice == 4:
        print("--- Видалення постачальника ---")
        sup_id = get_input("Введіть ID для видалення: ", ctype=int)
        if sup_id is not None:
            rep.delete(sup_id)
            print("Постачальника видалено")

    if choice == 5:
        print("На все добре!")
        break
