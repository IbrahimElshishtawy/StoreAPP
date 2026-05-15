from playwright.sync_api import sync_playwright
import time

def run():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        # Increase viewport for desktop view
        page.set_viewport_size({"width": 1280, "height": 800})

        try:
            # Navigate to the app
            page.goto("http://localhost:8080")

            # Wait for the app to load
            time.sleep(10)

            # Take a screenshot of the home page
            page.screenshot(path="verification/home_page.png")
            print("Home page screenshot taken")

            # Try to navigate to Search page (assuming it's the 3rd item in BottomNavigationBar)
            # Find the search icon/label and click it
            search_button = page.get_by_text("Search")
            if search_button.count() > 0:
                search_button.first.click()
                time.sleep(2)
                page.screenshot(path="verification/search_page.png")
                print("Search page screenshot taken")

            # Try to navigate to Cart page
            cart_button = page.get_by_text("Cart")
            if cart_button.count() > 0:
                cart_button.first.click()
                time.sleep(2)
                page.screenshot(path="verification/cart_page.png")
                print("Cart page screenshot taken")

        except Exception as e:
            print(f"Error: {e}")
            page.screenshot(path="verification/error.png")
        finally:
            browser.close()

if __name__ == "__main__":
    run()
