# What is requirements.txt?

## 1. What is requirements.txt?
In our DevOps project, the `requirements.txt` file contains the Python packages (libraries) that our application needs to run.
It does not contain the application code. It only lists the external packages that the application depends on.

## 2. What do we include in requirements.txt?
For our Flask application, the file contains: Flask

**Explanation:**
* Flask is a Python package used to create and run our web application.
* We list the required Python packages in this file.
* If our application requires additional external packages, we can list them here as well.

## 3. Why do we use requirements.txt?
Suppose we develop our application on one computer and then want to run it on another computer or server.
The new environment might not have Flask installed. Instead of installing each package manually, we can install the required packages using a single command: pip install -r requirements.txt

### Explanation of the command
* pip — the Python package installer.
* install — tells pip to install packages.
* -r — tells pip to read package names from a file.
* requirements.txt — the file containing the package list.

## 4. How does it work in our DevOps project?
The basic flow is:
requirements.txt → Install Dependencies → Run `app.py` → Application Starts
First, we install the required dependencies:
pip install -r requirements.txt
Then, we start our application:
python app.py
Because Flask is installed, our application can import Flask and use its functionality.

## 5. How is requirements.txt used in CI/CD?
In our DevOps project, Jenkins can read `requirements.txt` and install the required Python packages during the pipeline.
This helps ensure that the dependencies are installed before running application tests or preparing the application for deployment.
The general DevOps flow is:
Developer → GitHub → Jenkins → Install Dependencies → Test Application → Build Docker Image → Deploy Application

## 6. Important Point
requirements.txt helps us manage and install application dependencies consistently across different environments.
For more reproducible installations, we can also specify package versions, for example:
Flask==3.1.0
This tells pip to install that specific Flask version, provided it is available for the environment.
**In simple words:** app.py contains the application code, `requirements.txt` lists its dependencies, and `pip` installs those dependencies.
