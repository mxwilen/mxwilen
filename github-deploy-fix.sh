rm -rf docs/*

flutter build web --base-href /mxwilen/

cp -r build/web/ docs/

echo "--- READY FOR GIT PUSH TO MAIN BRANCH ---"
