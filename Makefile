# Send coverage report from node 6 builds of any branch

CURBUILD = "$(TRAVIS_NODE_VERSION)"
REQBUILD = "6.0.0"

setup_cover:
ifeq ($(CURBUILD),$(REQBUILD))
	@ npm i -g codecov codacy-coverage
	@ curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
	@ chmod +x ./cc-test-reporter
	@ ./cc-test-reporter before-build
endif

send_cover:
ifeq ($(CURBUILD),$(REQBUILD))
	@ echo Sending coverage report...
	@ nyc report -r=lcov
	@ codecov -f ./coverage/lcov.info
	@ ./cc-test-reporter after-build --exit-code $(TRAVIS_TEST_RESULT)
	@ cat ./coverage/lcov.info | codacy-coverage -p . --language typescript
	@ echo The report was sent.
else
	@ echo The coverage report will be sent in $(REQBUILD)
endif

.PHONY: setup_cover send_cover
